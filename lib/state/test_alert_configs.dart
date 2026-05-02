import 'package:flutter/material.dart';

class AlertConfig {
  final String message;
  final List<Color> gradientColors;

  const AlertConfig({
    required this.message,
    required this.gradientColors,
  });
}

class TestAlertConfigs {
  // Original bilirubin configuration from our correct layout code
  static const bilirubin = AlertConfig(
    message: "bilirubin too high",
    gradientColors: [Color(0xFFFFF49C), Colors.white], // The strong yellow matching image_8.png layout
  );

  // New alert configurations based on image_12.png
  static const glucose = AlertConfig(
    message: "Glucose too Low",
    gradientColors: [Color(0xFFE5DFFF), Colors.white], // Purple/Lavender gradient
  );

  static const hemoglobin = AlertConfig(
    message: "Hemoglobin too Low",
    gradientColors: [Color(0xFFFFDFF3), Colors.white], // Pink gradient
  );

  static const oxygen = AlertConfig(
    message: "Oxygen too low",
    gradientColors: [Color(0xFFFFE5BF), Colors.white], // Orange/Peach gradient
  );
}