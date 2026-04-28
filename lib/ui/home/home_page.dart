import 'package:flutter/material.dart';
import '../notifications/notification_page.dart';
import 'widgets/device_card.dart';
import 'widgets/data_row_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grey app background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with Blue Curve
            Stack(
              children: [
                // Blue background
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    color: Color(0xFF98C1FF), // Soft blue from your design
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
                        // 2.1 Top Bar
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              // Replace with actual image later: backgroundImage: AssetImage('assets/baby.png'),
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

                        // 2.2 Horizontal Slider for Devices
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
                                title: "NEOLA wristband 068-1",
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

            // 2.3 Data Table Section
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
                  
                  // The 4 Data Rows
                  DataRowCard(value: "35", unit: "mg/dl", title: "Bilirubin", status: "Safe", borderColor: Colors.greenAccent.shade400),
                  const SizedBox(height: 10),
                  DataRowCard(value: "50", unit: "mg/dl", title: "Glucose", status: "Safe", borderColor: Colors.orangeAccent),
                  const SizedBox(height: 10),
                  DataRowCard(value: "40", unit: "mg/dl", title: "Hemoglobin", status: "Safe", borderColor: Colors.pinkAccent.shade100),
                  const SizedBox(height: 10),
                  DataRowCard(value: "40", unit: "%", title: "Oxygen", status: "Safe", borderColor: Colors.orangeAccent),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}