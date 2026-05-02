import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/notification_state.dart';
import '../../state/test_alert_configs.dart'; // Import configs
import '../notifications/notification_page.dart';
import '../notifications/generic_alert_page.dart'; // Import generalized page
import 'widgets/device_card.dart';
import 'widgets/data_row_card.dart';

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

  // Generalized test event function accepting alert configuration
  void _triggerTestEvent(AlertConfig config) {
    int secondsRemaining = 3;

    // 1. Save Test Notification Data first
    ref.read(notificationProvider.notifier).addTestNotification("${config.message} (Test Event)");

    // 2. Show Small Countdown Popup at bottom
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: StatefulBuilder(
            builder: (context, setOverlayState) {
              Timer.periodic(const Duration(seconds: 1), (timer) {
                if (secondsRemaining > 0) {
                  secondsRemaining--;
                  if (mounted) setOverlayState(() {});
                } else {
                  timer.cancel();
                }
              });

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

    // 3. Navigation Countdown (Wait 3 seconds)
    _countdownTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        overlayEntry.remove();

        // Navigate to the generic alert page, passing specific configurations
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with Blue Curve
            Stack(
              children: [
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    color: Color(0xFF98C1FF),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
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
                            const CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.child_care, color: Colors.blue),
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

                        // Horizontal Slider for Devices
                        SizedBox(
                          height: 180,
                          child: PageView(
                            controller: PageController(viewportFraction: 0.95),
                            children: const [
                              DeviceCard(
                                title: "Increasing light intensity",
                                value: "30",
                                unit: "nm",
                                deviceName: "Phototherapy",
                              ),
                              DeviceCard(
                                title: "NEOLA wristband\n068-1",
                                value: "68%",
                                unit: "17hr life",
                                deviceName: "Neola",
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
                    value: "35", unit: "mg/dl", title: "Bilirubin", status: "Safe", 
                    borderColor: Colors.greenAccent.shade400,
                    onTap: () => _triggerTestEvent(TestAlertConfigs.bilirubin), // Trigger Bilirubin Alert
                  ),
                  const SizedBox(height: 10),
                  
                  // Glucose Card
                  DataRowCard(
                    value: "50", unit: "mg/dl", title: "Glucose", status: "Safe", 
                    borderColor: Colors.orangeAccent,
                    onTap: () => _triggerTestEvent(TestAlertConfigs.glucose), // Trigger Glucose Alert
                  ),
                  const SizedBox(height: 10),
                  
                  // Hemoglobin Card
                  DataRowCard(
                    value: "40", unit: "mg/dl", title: "Hemoglobin", status: "Safe", 
                    borderColor: Colors.pinkAccent.shade100,
                    onTap: () => _triggerTestEvent(TestAlertConfigs.hemoglobin), // Trigger Hemoglobin Alert
                  ),
                  const SizedBox(height: 10),
                  
                  // Oxygen Card
                  DataRowCard(
                    value: "40", unit: "%", title: "Oxygen", status: "Safe", 
                    borderColor: Colors.orangeAccent,
                    onTap: () => _triggerTestEvent(TestAlertConfigs.oxygen), // Trigger Oxygen Alert
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