import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/notification_state.dart';
import '../../state/test_alert_configs.dart';
import '../notifications/notification_page.dart';
import '../notifications/generic_alert_page.dart';
import 'widgets/device_card.dart';
import 'widgets/data_row_card.dart';
import '../../state/bluetooth_state.dart';
import 'bluetooth_connection_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Timer? _countdownTimer;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _triggerTestEvent(AlertConfig config) {
    int secondsRemaining = 3;
    StateSetter? updateOverlay;

    ref.read(notificationProvider.notifier).addTestNotification("${config.message} (Test Event)");

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: StatefulBuilder(
            builder: (context, setOverlayState) {
              updateOverlay = setOverlayState;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 2),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "Incoming Alert in $secondsRemaining seconds...",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Timer? localPeriodicTimer;
    localPeriodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        if (mounted && updateOverlay != null) {
          updateOverlay!(() {});
        }
      } else {
        timer.cancel();
      }
    });

    _countdownTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        localPeriodicTimer?.cancel();
        overlayEntry.remove();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenericAlertPage(
              message: config.message,
              gradientColors: config.gradientColors,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bluetoothState = ref.watch(bluetoothProvider);
    final phototherapyState = bluetoothState.phototherapy;
    final wristbandState = bluetoothState.wristband;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with Blue Curve
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Secondary light blue circle (shadow peeking out)
                // Positioned(
                //   top: -510,
                //   // Center this circle at 35% of the screen width (shifted further left)
                //   left: (screenWidth * 0.35) - 400, 
                //   child: Container(
                //     width: 800,
                //     height: 800,
                //     decoration: const BoxDecoration(
                //       color: Color(0xFFD6E4FF), // Light shadow
                //       shape: BoxShape.circle,
                //     ),
                //   ),
                // ),
                // Main Blue Circle
                Positioned(
                  top: -460,
                  left: (screenWidth * 0.40) - 400, 
                  child: Container(
                    width: 800,
                    height: 800,
                    decoration: const BoxDecoration(
                      color: Color(0xFF98C1FF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Bar
                        Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundImage: AssetImage('assets/images/baby.png'),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF16A34A),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Baby Neo",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D)),
                                ),
                                Text(
                                  "6 Hours old",
                                  style: TextStyle(fontSize: 14, color: Colors.white),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Stack(
                                children: [
                                  Icon(Icons.notifications_none, color: Colors.white, size: 30),
                                  Positioned(
                                    right: 2,
                                    top: 2,
                                    child: CircleAvatar(radius: 5, backgroundColor: Colors.redAccent),
                                  )
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()));
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          height: 180,
                          child: PageView(
                            controller: PageController(viewportFraction: 0.95),
                            children: [
                              DeviceCard(
                                title: "Increasing\nlight intensity",
                                value: phototherapyState.isConnected ? phototherapyState.mainValue : "30",
                                unit: phototherapyState.isConnected ? phototherapyState.unit : "nm",
                                deviceName: "Phototherapy",
                                imagePath: 'assets/images/phototherapy.png',
                                imageWidth: 150,
                                imageBottom: -15,
                                imageRight: 10,
                                isConnected: phototherapyState.isConnected,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BluetoothConnectionPage(deviceType: "Phototherapy"),
                                    ),
                                  );
                                },
                              ),
                              DeviceCard(
                                title: wristbandState.isConnected 
                                    ? "NEOLA wristband\n${wristbandState.deviceName.replaceAll('NEOLA-Wristband-', '')}" 
                                    : "NEOLA wristband",
                                value: "68%",
                                unit: "17hr life",
                                deviceName: "Neola",
                                imagePath: 'assets/images/neola_band.png',
                                imageWidth: 230,
                                imageTop: 45,
                                isConnected: wristbandState.isConnected,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BluetoothConnectionPage(deviceType: "Wristband"),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Data Table Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today Data",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  
                  // Bilirubin Card
                  DataRowCard(
                    value: "35",
                    unit: "mg/dl",
                    title: "Billrubin",
                    status: "Safe",
                    borderColor: const Color(0xFFFDE047), // Yellow
                    valueColor: const Color(0xFF84CC16), // Green
                    onTap: () => _triggerTestEvent(TestAlertConfigs.bilirubin),
                  ),
                  const SizedBox(height: 10),
                  
                  // Glucose Card
                  DataRowCard(
                    value: "50",
                    unit: "mg/dl",
                    title: "Glucose",
                    status: "Safe",
                    borderColor: const Color(0xFFD8B4FE), // Light Purple
                    valueColor: const Color(0xFFF97316), // Orange
                    onTap: () => _triggerTestEvent(TestAlertConfigs.glucose),
                  ),
                  const SizedBox(height: 10),
                  
                  // Hemoglobin Card
                  DataRowCard(
                    value: "40",
                    unit: "mg/dl",
                    title: "Hemoglobin",
                    status: "Safe",
                    borderColor: const Color(0xFFF9A8D4), // Pink
                    valueColor: const Color(0xFF84CC16), // Green
                    onTap: () => _triggerTestEvent(TestAlertConfigs.hemoglobin),
                  ),
                  const SizedBox(height: 10),
                  
                  // Oxygen Card
                  DataRowCard(
                    value: "40",
                    unit: "%",
                    title: "Oxygen",
                    status: "Safe",
                    borderColor: const Color(0xFFFDBA74), // Light Orange
                    valueColor: const Color(0xFF84CC16), // Green
                    onTap: () => _triggerTestEvent(TestAlertConfigs.oxygen),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}