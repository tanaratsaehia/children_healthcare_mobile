import 'package:flutter/material.dart';

class DataRowCard extends StatelessWidget {
  final String value;
  final String unit;
  final String title;
  final String status;
  final Color borderColor;
  final VoidCallback? onTap; // Add this parameter

  const DataRowCard({
    super.key,
    required this.value,
    required this.unit,
    required this.title,
    required this.status,
    required this.borderColor,
    this.onTap, // Add this to constructor
  });

  @override
  Widget build(BuildContext context) {
    // Wrap with InkWell for ripple effect on tap
    return InkWell(
      onTap: onTap, // Hook up the tap event
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: borderColor)),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(unit, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(status, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
            const Spacer(),
            Icon(Icons.bookmark_border, color: Colors.blue.shade200),
          ],
        ),
      ),
    );
  }
}