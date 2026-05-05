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
            stops: const [0.0, 0.6], 
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              
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
              
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      size: 280,
                      color: Color(0xFFED5353),
                    ),

                    const Text(
                      "Caution!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 56, 
                        fontWeight: FontWeight.w900, 
                        color: Colors.black,
                        height: 1.1, 
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26, 
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 30), 

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40), 
                      width: double.infinity, 
                      height: 60, 
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
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDFF3FE), 
                          foregroundColor: const Color(0xFF1A1A1A), 
                          elevation: 0, 
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