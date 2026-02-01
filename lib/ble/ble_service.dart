import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/health_data.dart';
import 'ble_constants.dart';

class BleService {
  BluetoothDevice? _device;
  BluetoothCharacteristic? _notifyChar;

  // ---- CONNECTION STATE ----
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  // ---- DATA STREAM ----
  final StreamController<HealthData> _dataController =
      StreamController<HealthData>.broadcast();
  Stream<HealthData> get dataStream => _dataController.stream;

  bool _connected = false;

  // ---- PUBLIC INIT ----
  Future<void> init() async {
    await _requestPermissions();
    await _scanAndConnect();
    await _discoverAndSubscribe();
  }

  // ---- PERMISSIONS ----
  Future<void> _requestPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }

  // ---- SCAN + CONNECT ----
  Future<void> _scanAndConnect() async {
    print("BLE: Starting scan...");

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 8),
    );

    await for (final results in FlutterBluePlus.scanResults) {
      for (final r in results) {
        final name = r.device.platformName;

        print("BLE: Found $name");

        if (name == deviceName) {
          print("BLE: Target ESP32 found");

          await FlutterBluePlus.stopScan();

          _device = r.device;

          print("BLE: Connecting...");
          await _device!.connect(autoConnect: false);

          _connected = true;
          _connectionController.add(true);

          print("BLE: Connected");
          return;
        }
      }
    }

    throw Exception("BLE: ESP32 device not found");
  }

  // ---- DISCOVER + SUBSCRIBE ----
  Future<void> _discoverAndSubscribe() async {
    if (_device == null) {
      throw Exception("BLE: Device is null");
    }

    print("BLE: Discovering services...");
    final services = await _device!.discoverServices();

    for (final service in services) {
      print("BLE: Service ${service.uuid}");

      if (service.uuid == serviceUUID) {
        print("BLE: Target service found");

        for (final char in service.characteristics) {
          print("BLE: Characteristic ${char.uuid}");

          if (char.uuid == charUUID) {
            print("BLE: Notify characteristic found");

            _notifyChar = char;

            await _notifyChar!.setNotifyValue(true);
            _notifyChar!.lastValueStream.listen(_onData);

            print("BLE: Notifications enabled");
            return;
          }
        }
      }
    }

    throw Exception("BLE: Notify characteristic NOT FOUND");
  }

  // ---- DATA HANDLER ----
  void _onData(List<int> value) {
    final raw = String.fromCharCodes(value);
    print("BLE RAW DATA: $raw");

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final data = HealthData.fromJson(map);
      _dataController.add(data);
    } catch (e) {
      print("BLE PARSE ERROR: $e");
    }
  }

  // ---- CLEANUP ----
  void dispose() {
    if (_connected) {
      _connectionController.add(false);
    }

    _connectionController.close();
    _dataController.close();

    _device?.disconnect();
  }
}