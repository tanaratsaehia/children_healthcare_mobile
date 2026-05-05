import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/profile_state.dart';
import '../../state/notification_state.dart'; 
import '../onboarding/setup_profile_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFC6DAFE),
            ],
            stops: [0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            children: [
              const SizedBox(height: 20),
              
              const Text(
                "Neola",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                "Apps",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF3B3B3B),
                ),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildListTile(icon: Icons.settings_outlined, title: "Neola"),
                    _buildDivider(),
                    _buildListTile(icon: Icons.info_outline, title: "About Neola app"),
                    _buildDivider(),
                    _buildListTile(icon: Icons.share_outlined, title: "Share"),
                    _buildDivider(),
                    _buildListTile(icon: Icons.people_outline, title: "Join with us"),
                    _buildDivider(),
                    _buildListTile(icon: Icons.data_usage, title: "Mobile data"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildListTile(title: "Review", hideIcon: true),
                    _buildDivider(),
                    _buildListTile(title: "Feedback", hideIcon: true),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Tell use about the experience with the app", 
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: () => _showClearDataDialog(context, ref),
                icon: const Icon(Icons.delete_forever, color: Colors.white),
                label: const Text(
                  "Clear User Data (Debug)",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({IconData? icon, required String title, bool hideIcon = false}) {
    return ListTile(
      leading: hideIcon ? null : Icon(icon, color: const Color(0xFF4A6B8C)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF2D2D2D),
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black87),
      onTap: () {
        debugPrint("$title tapped");
      },
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 16.0), 
      child: Divider(height: 1, thickness: 0.5, color: Color(0xFFE5E5E5)),
    );
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    bool clearProfile = true; 
    bool clearHistory = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Clear Data"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Which data do you want to clear?"),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text("Baby profile"),
                    value: clearProfile,
                    activeColor: const Color(0xFF6B9BFF),
                    onChanged: (bool? value) {
                      setState(() {
                        clearProfile = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("History data"),
                    value: clearHistory,
                    activeColor: const Color(0xFF6B9BFF),
                    onChanged: (bool? value) {
                      setState(() {
                        clearHistory = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext), 
                  child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (clearProfile) {
                      ref.read(profileProvider.notifier).saveProfile(
                            age: '',
                            weight: '',
                            gender: '',
                            gestationalAge: '',
                          );
                    }

                    if (clearHistory) {
                      ref.read(notificationProvider.notifier).clearDynamicNotifications();
                    }

                    Navigator.pop(dialogContext);

                    if (clearProfile) {
                       Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const SetupProfilePage()),
                          (Route<dynamic> route) => false, 
                        );
                    } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text("Selected history data cleared."))
                        );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  child: const Text("Confirm", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}