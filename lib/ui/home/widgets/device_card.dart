import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String deviceName;
  final String imagePath;
  final double? imageWidth;
  final double? imageHeight;
  final double? imageTop;
  final double? imageBottom;
  final double? imageLeft;
  final double? imageRight;

  const DeviceCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.deviceName,
    required this.imagePath,
    this.imageWidth,
    this.imageHeight,
    this.imageTop,
    this.imageBottom,
    this.imageLeft,
    this.imageRight,
  });

  @override
  Widget build(BuildContext context) {
    bool isNeola = deviceName == "Neola";

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            // Image
            Positioned(
              top: imageTop ?? (isNeola ? 35 : null),
              bottom: imageBottom ?? (isNeola ? null : 10),
              left: imageLeft ?? (isNeola ? -10 : null),
              right: imageRight ?? (isNeola ? null : -10),
              child: SizedBox(
                width: imageWidth ?? (isNeola ? 180 : 190),
                height: imageHeight,
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),

            // Title and Bluetooth Icon
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bluetooth,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Value and Unit
            Positioned(
              bottom: 15,
              left: isNeola ? null : 0,
              right: isNeola ? 0 : null,
              child: isNeola
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          value,
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF65B700),
                            height: 1.0,
                          ),
                        ),
                        Text(
                          unit,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.0,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          value,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          unit,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
            ),

            // The dots at the bottom
            const Positioned(
              bottom: 5,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "...",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    height: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
