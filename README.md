# Health Monitor Wearable Device

**Health Monitor** is a real-time health monitoring system that collects physiological data using an ESP32 wearable device and streams it to a Flutter mobile application via **Bluetooth Low Energy (BLE)**.

---

## 🔍 Project Overview

This system integrates:
- **Wearable embedded sensors** (heart rate, SpO₂, ECG, temperature, accelerometer)
- **ESP32 microcontroller** for BLE data streaming
- **Flutter mobile application** for live visualization and alerts

The device captures health metrics and continuously transmits them to the app, which shows them in real time through interactive widgets.

---

## 🚀 Key Features

### Wearable Device Capabilities
- **Heart rate & SpO₂ monitoring**
- **ECG waveform streaming**
- **Body temperature measurement**
- **Fall detection using accelerometer**

### Mobile App (Flutter)
- Live BLE scanning and automatic connection
- Health rings for quick metric visualization
- Real-time ECG waveform plot
- Fall alert and notification UI
- Multi-page navigation and modular UI design

---

## 🧠 System Workflow

```
ESP32 Sensors
    ↓ BLE
Flutter App (Android)
    ↓ UI Rendering
Dashboard, ECG Plot, Alerts
```

---

## ⚙️ Getting Started

### 🧾 Requirements
- Flutter SDK installed
- Android device with Bluetooth
- ESP32 firmware uploaded

### 📦 Install Dependencies

```bash
flutter pub get
```

### 🔌 Connect Phone
Enable Bluetooth and Location permissions.

### ▶️ Run App

```bash
flutter run
```

---

## 🧩 BLE Data Format

ESP32 streams analytics in JSON:

```json
{
  "hr": 78,
  "spo2": 97,
  "temp": 36.5,
  "ecg": 512,
  "fall": false
}
```

The app decodes and visualizes this.

---

## 📌 Future Enhancements

- Cloud data storage (Firestore)
- User profiles and settings
- Historical session logs
- Remote data viewing for doctors
- Alerts via SMS or push notifications

---

## 📁 Repository Structure

```
lib/
 ├─ ble/
 ├─ models/
 ├─ ui/
 ├─ services/
android/
ios/
test/
pubspec.yaml
```

---

## 👤 Author

**Harshit P**  
Engineering Student — VLSI,Embedded Systems, Biomedical Tech, Mobile Dev  
📍 India

---

## 🔗 License

*(Add your license info — MIT/Apache/Proprietary, if any)*

