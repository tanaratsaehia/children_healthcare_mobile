import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String deviceName;

  const DeviceCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.deviceName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Icon(Icons.bluetooth, color: Colors.black),
              ],
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(width: 8),
                Text(unit, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const Center(child: Text("...", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey))),
          ],
        ),
      ),
    );
  }
}