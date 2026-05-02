import 'package:flutter/material.dart';
import '../notifications/notification_page.dart';

// ==========================================
// 1. DATA MODEL (Production Ready)
// ==========================================
// In production, you will generate a List of these objects from your ESP32/Cloud data.
class HistoryRecord {
  final String title; // e.g., "Hours1"
  final String date; // e.g., "18/02/26"
  final double bilirubin;
  final double glucose;
  final double haemoglobin;
  final double spo2;
  final String overallStage;

  HistoryRecord({
    required this.title,
    required this.date,
    required this.bilirubin,
    required this.glucose,
    required this.haemoglobin,
    required this.spo2,
    required this.overallStage,
  });
}

// ==========================================
// 2. THE RULE ENGINE (Easily Editable)
// ==========================================
// Edit these thresholds when you finalize your medical parameters.
class HealthRules {
  static Color evaluateFactorColor(String factorName, double value) {
    // Currently, using a universal rule for the mockup.
    // You can split this into 'if (factorName == "Bilirubin") { ... }' later.
    if (value < 40) return const Color(0xFF7ED321); // Normal (Green)
    if (value < 60)
      return const Color.fromARGB(255, 212, 195, 10); // Stage 1 (Yellow)
    if (value < 80)
      return const Color.fromARGB(255, 254, 157, 0); // Stage 2 (Orange)
    return const Color(0xFFD0021B); // Stage 3 (Red)
  }

  static Color evaluateStageColor(String stage) {
    switch (stage.toLowerCase()) {
      case 'normal':
        return const Color(0xFF7ED321);
      case 'stage 1':
        return const Color.fromARGB(255, 212, 195, 10);
      case 'stage 2':
        return const Color.fromARGB(255, 254, 157, 0);
      case 'stage 3':
        return const Color(0xFFD0021B);
      default:
        return Colors.grey;
    }
  }
}

// ==========================================
// 3. THE UI PAGE
// ==========================================
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Mockup Data - Replace this list with an API call in production
  final List<HistoryRecord> mockData = [
    HistoryRecord(
      title: "Hours1",
      date: "18/02/26",
      bilirubin: 35,
      glucose: 35,
      haemoglobin: 35,
      spo2: 35,
      overallStage: "Normal",
    ),
    HistoryRecord(
      title: "Hours2",
      date: "18/02/26",
      bilirubin: 43,
      glucose: 45,
      haemoglobin: 47,
      spo2: 47,
      overallStage: "Stage 1",
    ),
    HistoryRecord(
      title: "Hours3",
      date: "18/02/26",
      bilirubin: 76,
      glucose: 68,
      haemoglobin: 77,
      spo2: 68,
      overallStage: "Stage 2",
    ),
    HistoryRecord(
      title: "Hours4",
      date: "18/02/26",
      bilirubin: 99,
      glucose: 99,
      haemoglobin: 99,
      spo2: 99,
      overallStage: "Stage 3",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF98C1FF), // Top blue background
      body: SafeArea(
        bottom: false, // Allows the white container to go all the way down
        child: Column(
          children: [
            // --- Custom Top App Bar ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  // Back Button (Hides Bottom Nav automatically because it pops the page)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFFE96B6B),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Neola",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  // Notification Icon
                  IconButton(
                    icon: const Stack(
                      children: [
                        Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: 32,
                        ),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: Color(0xFFFF4B4B),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      // Pushes the Notification page over the History page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // --- Main White Body ---
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 24.0,
                        top: 24.0,
                        bottom: 16.0,
                      ),
                      child: Text(
                        "History",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    // --- History List ---
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: mockData.length,
                        itemBuilder: (context, index) {
                          return _buildHistoryCard(mockData[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build the outer light-blue card
  Widget _buildHistoryCard(HistoryRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F0FE), // Light blue background
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                record.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  record.date,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                record.overallStage,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: HealthRules.evaluateStageColor(record.overallStage),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Data Pills Row 1
          Row(
            children: [
              Expanded(
                child: _buildDataPill("Bilirubin", record.bilirubin, "mg/dl"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDataPill("Glucose", record.glucose, "mg/dl"),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Data Pills Row 2
          Row(
            children: [
              Expanded(
                child: _buildDataPill(
                  "Haemoglobin",
                  record.haemoglobin,
                  "mg/dl",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildDataPill("Spo2", record.spo2, "%")),
            ],
          ),
        ],
      ),
    );
  }

  // Widget to build the inner white data pills
  Widget _buildDataPill(String title, double value, String unit) {
    // 1. Evaluate the color using our Rule Engine
    Color valueColor = HealthRules.evaluateFactorColor(title, value);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30), // Pill shape
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Stack to position the unit slightly below the number
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value.toInt().toString(),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
