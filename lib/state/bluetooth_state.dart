import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class DeviceConnectionData {
  final bool isConnected;
  final String deviceName;
  final String mainValue;
  final String secondaryValue;
  final String unit;

  const DeviceConnectionData({
    this.isConnected = false,
    this.deviceName = '',
    this.mainValue = '',
    this.secondaryValue = '',
    this.unit = '',
  });

  DeviceConnectionData copyWith({
    bool? isConnected,
    String? deviceName,
    String? mainValue,
    String? secondaryValue,
    String? unit,
  }) {
    return DeviceConnectionData(
      isConnected: isConnected ?? this.isConnected,
      deviceName: deviceName ?? this.deviceName,
      mainValue: mainValue ?? this.mainValue,
      secondaryValue: secondaryValue ?? this.secondaryValue,
      unit: unit ?? this.unit,
    );
  }
}

class BluetoothAppState {
  final DeviceConnectionData wristband;
  final DeviceConnectionData phototherapy;

  const BluetoothAppState({
    this.wristband = const DeviceConnectionData(),
    this.phototherapy = const DeviceConnectionData(),
  });

  BluetoothAppState copyWith({
    DeviceConnectionData? wristband,
    DeviceConnectionData? phototherapy,
  }) {
    return BluetoothAppState(
      wristband: wristband ?? this.wristband,
      phototherapy: phototherapy ?? this.phototherapy,
    );
  }
}

class BluetoothNotifier extends Notifier<BluetoothAppState> {
  @override
  BluetoothAppState build() {
    return const BluetoothAppState();
  }

  Future<void> connectToDevice(BluetoothDevice device, String deviceType) async {
    try {
      await device.connect();
      
      // Update UI to show connected status
      _updateConnectionState(deviceType, true, device.platformName, "Waiting...", deviceType == "Wristband" ? "ir" : "nm");

      // Discover services
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        if (service.uuid.toString().toUpperCase() == "6E400001-B5A3-F393-E0A9-E50E24DCCA9E") {
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid.toString().toUpperCase() == "6E400003-B5A3-F393-E0A9-E50E24DCCA9E") {
              await characteristic.setNotifyValue(true);
              
              // Listen for incoming data
              characteristic.onValueReceived.listen((value) {
                try {
                  String dataString = utf8.decode(value).trim();
                  // Expected format: "32000,30000"
                  List<String> parts = dataString.split(',');
                  if (parts.isNotEmpty) {
                    String irValue = parts[0].trim();
                    _updateMainValue(deviceType, irValue);
                  }
                } catch (e) {
                  debugPrint("Error parsing BLE data: $e");
                }
              });
            }
          }
        }
      }

      // Listen for disconnects
      device.connectionState.listen((connectionState) {
        if (connectionState == BluetoothConnectionState.disconnected) {
          _updateConnectionState(deviceType, false, "", "", "");
        }
      });
      
    } catch (e) {
      debugPrint("Connection error: $e");
    }
  }

  void mockConnection(String deviceType) {
    if (deviceType == "Wristband") {
      state = state.copyWith(
        wristband: state.wristband.copyWith(
          isConnected: true,
          deviceName: "NEOLA-Wristband-068-1",
          mainValue: "32000",
          unit: "ir",
        ),
      );
    } else {
      state = state.copyWith(
        phototherapy: state.phototherapy.copyWith(
          isConnected: true,
          deviceName: "NEOLA-Phototherapy-068-1",
          mainValue: "30",
          unit: "nm",
        ),
      );
    }
  }

  void disconnectMock(String deviceType) {
    if (deviceType == "Wristband") {
      state = state.copyWith(wristband: const DeviceConnectionData());
    } else {
      state = state.copyWith(phototherapy: const DeviceConnectionData());
    }
  }

  Future<void> disconnectDevice(String deviceType) async {
    try {
      List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;
      for (BluetoothDevice d in connectedDevices) {
        if (d.platformName.startsWith("NEOLA-$deviceType-")) {
           await d.disconnect();
        }
      }
    } catch (e) {
      debugPrint("Error disconnecting: $e");
    }
    
    if (deviceType == "Wristband") {
      state = state.copyWith(wristband: const DeviceConnectionData());
    } else {
      state = state.copyWith(phototherapy: const DeviceConnectionData());
    }
  }

  void _updateConnectionState(String deviceType, bool isConnected, String name, String value, String unit) {
    if (deviceType == "Wristband") {
      state = state.copyWith(
        wristband: state.wristband.copyWith(
          isConnected: isConnected,
          deviceName: name,
          mainValue: value,
          unit: unit,
        ),
      );
    } else {
      state = state.copyWith(
        phototherapy: state.phototherapy.copyWith(
          isConnected: isConnected,
          deviceName: name,
          mainValue: value,
          unit: unit,
        ),
      );
    }
  }

  void _updateMainValue(String deviceType, String value) {
    if (deviceType == "Wristband") {
      state = state.copyWith(
        wristband: state.wristband.copyWith(mainValue: value),
      );
    } else {
      state = state.copyWith(
        phototherapy: state.phototherapy.copyWith(mainValue: value),
      );
    }
  }
}

final bluetoothProvider = NotifierProvider<BluetoothNotifier, BluetoothAppState>(() {
  return BluetoothNotifier();
});
