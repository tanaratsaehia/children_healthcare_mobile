import 'package:flutter/material.dart';

class DataRowCard extends StatelessWidget {
  final String value;
  final String unit;
  final String title;
  final String status;
  final Color borderColor;
  final Color valueColor;
  final VoidCallback? onTap;

  const DataRowCard({
    super.key,
    required this.value,
    required this.unit,
    required this.title,
    required this.status,
    required this.borderColor,
    required this.valueColor,
    this.onTap,
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
          border: Border.all(color: borderColor, width: 5),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 110, // Fixed width for value+unit to align columns
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    unit,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.bookmark_border, color: Colors.blue.shade300),
          ],
        ),
      ),
    );
  }
}