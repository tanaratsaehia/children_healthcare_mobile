import 'package:flutter/material.dart';
import 'home/home_page.dart';
import 'settings/settings_page.dart';
import 'history/history_page.dart'; // Make sure this is imported!

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Start on the Home tab (index 1)
  int _currentIndex = 1; 

  // The pages that correspond to the bottom nav tabs
  final List<Widget> _pages = [
    const SizedBox(), // Index 0: Placeholder for History (we push this page instead of embedding it)
    const HomePage(),   // Index 1: Home
    const SettingsPage(), // Index 2: Settings
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05), 
              blurRadius: 10, 
              offset: const Offset(0, -5)
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            // Check if the user tapped the History tab (Index 0)
            if (index == 0) {
              // Push the History page OVER the bottom navigation bar
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            } else {
              // For Home (1) and Settings (2), switch tabs normally
              setState(() {
                _currentIndex = index;
              });
            }
          },
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}