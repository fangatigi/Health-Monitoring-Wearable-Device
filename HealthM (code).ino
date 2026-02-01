#include <Wire.h>
#include <math.h>

#include <MPU6050.h>
#include <MAX30100_PulseOximeter.h>
#include <Adafruit_MLX90614.h>

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

// ---------------- CONFIG ----------------
#define ECG_PIN 34

#define SERVICE_UUID        "12345678-1234-1234-1234-1234567890ab"
#define CHARACTERISTIC_UUID "abcd1234-5678-1234-5678-abcdef123456"

#define FALL_ACCEL_THRESHOLD 2.5

// ---------------- OBJECTS ----------------
MPU6050 mpu;
PulseOximeter pox;
Adafruit_MLX90614 mlx = Adafruit_MLX90614();

BLECharacteristic *pCharacteristic;
bool deviceConnected = false;

// ---------------- BLE CALLBACKS ----------------
class ServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer*) {
    deviceConnected = true;
  }
  void onDisconnect(BLEServer* server) {
    deviceConnected = false;
    server->startAdvertising();
  }
};

// ---------------- SETUP ----------------
void setup() {
  Serial.begin(115200);
  Wire.begin();

  // MPU6050
  if (!mpu.testConnection()) {
    Serial.println("MPU6050 FAIL");
    while (1);
  }

  // MAX30100
  if (!pox.begin()) {
    Serial.println("MAX30100 FAIL");
    while (1);
  }
  pox.setIRLedCurrent(MAX30100_LED_CURR_7_6MA);

  // MLX90614
  if (!mlx.begin()) {
    Serial.println("MLX90614 FAIL");
    while (1);
  }

  // BLE
  BLEDevice::init("ESP32_HealthMonitor");
  BLEServer *server = BLEDevice::createServer();
  server->setCallbacks(new ServerCallbacks());

  BLEService *service = server->createService(SERVICE_UUID);

  pCharacteristic = service->createCharacteristic(
    CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_NOTIFY |
    BLECharacteristic::PROPERTY_READ
  );

  pCharacteristic->addDescriptor(new BLE2902());
  service->start();
  BLEDevice::getAdvertising()->start();

  Serial.println("ESP32 READY");
}

// ---------------- LOOP ----------------
void loop() {
  pox.update();   // REQUIRED

  if (!deviceConnected) {
    delay(100);
    return;
  }

  // -------- MAX30100 --------
  float hr = pox.getHeartRate();
  float spo2 = pox.getSpO2();

  if (hr < 30 || hr > 220) hr = 0;
  if (spo2 < 70 || spo2 > 100) spo2 = 0;

  // -------- TEMP --------
  float temp = mlx.readObjectTempC();
  if (isnan(temp)) temp = -1.0;

  // -------- ECG --------
  int ecg = analogRead(ECG_PIN);

  // -------- MPU6050 --------
  int16_t ax, ay, az;
  mpu.getAcceleration(&ax, &ay, &az);

  float axg = ax / 16384.0;
  float ayg = ay / 16384.0;
  float azg = az / 16384.0;

  float accMag = sqrt(axg*axg + ayg*ayg + azg*azg);
  int fall = accMag > FALL_ACCEL_THRESHOLD ? 1 : 0;

  // -------- JSON (ALWAYS VALID) --------
  char json[160];
  snprintf(
    json, sizeof(json),
    "{\"hr\":%.1f,\"spo2\":%.1f,\"temp\":%.2f,\"ecg\":%d,\"fall\":%d}",
    hr, spo2, temp, ecg, fall
  );

  pCharacteristic->setValue(json);
  pCharacteristic->notify();

  Serial.println(json);
  delay(200); // 5 Hz
}
