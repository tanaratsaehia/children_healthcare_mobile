import 'package:flutter/material.dart';

class GenericAlertPage extends StatelessWidget {
  final String message;
  final List<Color> gradientColors;

  const GenericAlertPage({
    super.key,
    required this.message,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
            stops: const [0.0, 0.6], // Transition stops to match design
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              
              // Header Text "Neola" - always white to match design
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Neola",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0), 
                  ),
                ),
              ),
              
              // Use Expanded to vertically group content in the visual center
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Main Alert Icon
                    const Icon(
                      Icons.warning_rounded,
                      size: 280, // Massive icon from design
                      color: Color(0xFFED5353), // Soft red matching mockup
                    ),

                    // "Caution!" Text
                    const Text(
                      "Caution!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 56, 
                        fontWeight: FontWeight.w900, // Extra heavy bold
                        color: Colors.black,
                        height: 1.1, // Keeps text tight
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Message text - dynamic parameter
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26, 
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),

                    // Tight spacing between text and button
                    const SizedBox(height: 30), 

                    // "Understood" Button with shadow container
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40), 
                      width: double.infinity, // Stretches button width
                      height: 60, // Fixed height for chunky design
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate back to HomePage (popping the alert stack)
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDFF3FE), // Very light blue
                          foregroundColor: const Color(0xFF1A1A1A), 
                          elevation: 0, // Shadows handled by container
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Understood",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    
                    // Spacer at bottom to keep the Whole central block balanced
                    const SizedBox(height: 40), 
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}