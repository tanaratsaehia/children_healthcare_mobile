import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../state/bluetooth_state.dart';

class BluetoothConnectionPage extends ConsumerStatefulWidget {
  final String deviceType; // "Wristband" or "Phototherapy"

  const BluetoothConnectionPage({super.key, required this.deviceType});

  @override
  ConsumerState<BluetoothConnectionPage> createState() => _BluetoothConnectionPageState();
}

class _BluetoothConnectionPageState extends ConsumerState<BluetoothConnectionPage> {
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  bool _isSimulator = false;
  bool _showAllDevices = false;
  bool _wasAlreadyConnected = false;

  @override
  void initState() {
    super.initState();
    final bluetoothState = ref.read(bluetoothProvider);
    final isConnected = widget.deviceType == "Wristband" 
        ? bluetoothState.wristband.isConnected 
        : bluetoothState.phototherapy.isConnected;
    
    if (isConnected) {
      _wasAlreadyConnected = true;
      final deviceName = widget.deviceType == "Wristband" 
          ? bluetoothState.wristband.deviceName 
          : bluetoothState.phototherapy.deviceName;
      _isSimulator = deviceName.contains("Sim");
    } else {
      _initBluetooth();
    }
  }

  Future<void> _initBluetooth() async {
    // Check if device supports Bluetooth
    bool isSupported = false;
    try {
      isSupported = await FlutterBluePlus.isSupported;
    } catch (e) {
      debugPrint("Error checking Bluetooth support: $e");
    }

    if (!isSupported) {
      debugPrint("Bluetooth not supported by this device");
      setState(() {
        _isSimulator = true;
      });
      return;
    }

    // Turn on Bluetooth (Android only, iOS prompts automatically)
    if (Platform.isAndroid) {
      try {
        await FlutterBluePlus.turnOn();
      } catch (e) {
        debugPrint("Could not turn on Bluetooth: $e");
      }
    }

    _startScan();
  }

  void _startScan() async {
    if (_isSimulator) return;

    setState(() {
      _isScanning = true;
      _scanResults.clear();
    });

    try {
      // Listen to scan results
      var subscription = FlutterBluePlus.onScanResults.listen((results) {
        if (results.isNotEmpty) {
          // Filter by device prefix
          String prefix = "NEOLA-${widget.deviceType}-";
          var filtered = _showAllDevices 
              ? results.toList() 
              : results.where((r) => r.device.platformName.startsWith(prefix)).toList();
          
          if (mounted) {
            setState(() {
              _scanResults = filtered;
            });
          }
        }
      }, onError: (e) => debugPrint(e.toString()));

      // Cleanup
      FlutterBluePlus.cancelWhenScanComplete(subscription);

      // Start scan
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      debugPrint("Error starting scan: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  @override
  void dispose() {
    if (!_isSimulator) {
      try {
        FlutterBluePlus.stopScan();
      } catch (e) {
        // ignore
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch connection state
    final bluetoothState = ref.watch(bluetoothProvider);
    final isConnected = widget.deviceType == "Wristband" 
        ? bluetoothState.wristband.isConnected 
        : bluetoothState.phototherapy.isConnected;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Neola",
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFC0DAFF)],
            stops: [0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Big Bluetooth Icon
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.bluetooth,
                    size: 100,
                    color: Colors.black,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Status Text
              Text(
                isConnected 
                    ? "Bluetooth connected" 
                    : (_isSimulator ? "Simulator Mode" : (_isScanning ? "Scanning..." : "Not connected")),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              if (_isScanning)
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: CircularProgressIndicator(color: Colors.black),
                ),

              if (!isConnected && !_isSimulator)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showAllDevices = !_showAllDevices;
                    });
                    if (!_isScanning) _startScan();
                  },
                  child: Text(
                    _showAllDevices ? "Filter NEOLA devices only" : "Show all devices", 
                    style: const TextStyle(color: Colors.black54, decoration: TextDecoration.underline),
                  ),
                ),
              
              const SizedBox(height: 10),

              // Device List (if not connected and scanning)
              if (!isConnected && !_isSimulator && _scanResults.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: _scanResults.length,
                    itemBuilder: (context, index) {
                      final result = _scanResults[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(result.device.platformName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(result.device.remoteId.str),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Connect'),
                            onPressed: () {
                              FlutterBluePlus.stopScan();
                              ref.read(bluetoothProvider.notifier).connectToDevice(result.device, widget.deviceType);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

              if (!isConnected && _isSimulator)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Bluetooth is not supported on this device/simulator.\nUse the mock button below to test.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),

              const Spacer(),
              
              // Action Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (isConnected && _wasAlreadyConnected) ? Colors.red : const Color(0xFFE0F2FE),
                      foregroundColor: (isConnected && _wasAlreadyConnected) ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                    ),
                    onPressed: isConnected 
                        ? () {
                            if (_wasAlreadyConnected) {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: const Text("Disconnect Device"),
                                    content: Text("Are you sure you want to disconnect from the ${widget.deviceType}?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                        },
                                        child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext); // Close dialog
                                          if (_isSimulator) {
                                              ref.read(bluetoothProvider.notifier).disconnectMock(widget.deviceType);
                                          } else {
                                              ref.read(bluetoothProvider.notifier).disconnectDevice(widget.deviceType);
                                          }
                                          setState(() {
                                            _wasAlreadyConnected = false;
                                          });
                                          _initBluetooth();
                                        },
                                        child: const Text("Disconnect", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              Navigator.pop(context);
                            }
                        } 
                        : () {
                            if (_isSimulator) {
                                ref.read(bluetoothProvider.notifier).mockConnection(widget.deviceType);
                            } else if (!_isScanning) {
                                _startScan();
                            }
                        },
                    child: Text(
                      isConnected ? (_wasAlreadyConnected ? "Disconnect" : "Connected (Return)") : (_isSimulator ? "Mock Connect" : (_isScanning ? "Scanning..." : "Scan Again")),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
