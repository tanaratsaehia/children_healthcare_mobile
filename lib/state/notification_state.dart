import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Run 'flutter pub add intl' in terminal

// ==========================================
// DATA MODELS
// ==========================================

class NotificationAlert {
  final String message;
  final bool isCritical;
  final bool isDynamic; // TRUE if it's test data, FALSE if it's original mockup data

  NotificationAlert({
    required this.message,
    this.isCritical = true,
    this.isDynamic = false, // Defaults to false (original data)
  });
}

class DailyNotificationGroup {
  final String dateLabel;
  final List<NotificationAlert> alerts;

  DailyNotificationGroup({
    required this.dateLabel,
    required this.alerts,
  });
}

// ==========================================
// PRE-FIX MOCKUP DATA (Original)
// ==========================================
final List<DailyNotificationGroup> staticMockupData = [
  DailyNotificationGroup(
    dateLabel: "10 Oct. 2025",
    alerts: [
      NotificationAlert(message: "Bilirubin too high"),
      NotificationAlert(message: "Oxygen too high"),
      NotificationAlert(message: "Glucose too high"),
    ],
  ),
  DailyNotificationGroup(
    dateLabel: "9 Oct. 2025",
    alerts: [
      NotificationAlert(message: "Oxygen too low"),
    ],
  ),
  DailyNotificationGroup(
    dateLabel: "8 Oct. 2025",
    alerts: [
      NotificationAlert(message: "Bilirubin too high"),
      NotificationAlert(message: "Oxygen too high"),
    ],
  ),
];

// ==========================================
// RIVERPOD NOTIFIER
// ==========================================
class NotificationNotifier extends Notifier<List<DailyNotificationGroup>> {
  @override
  List<DailyNotificationGroup> build() {
    // Start with the initial mockup data
    return staticMockupData;
  }

  // Method to add a new test notification
  void addTestNotification(String message) {
    final now = DateTime.now();
    final formatter = DateFormat('d MMM. yyyy'); // e.g., "2 May. 2026"
    final todayLabel = formatter.format(now);

    final newAlert = NotificationAlert(
      message: message,
      isDynamic: true, // Mark as test data
    );

    // Create a NEW list instance to trigger UI update
    final List<DailyNotificationGroup> updatedState = List.from(state);

    // Check if a group for today already exists
    int todayIndex = updatedState.indexWhere((group) => group.dateLabel == todayLabel);

    if (todayIndex != -1) {
      // Group exists, add alert to the top of existing alerts list
      final currentGroup = updatedState[todayIndex];
      updatedState[todayIndex] = DailyNotificationGroup(
        dateLabel: currentGroup.dateLabel,
        alerts: [newAlert, ...currentGroup.alerts],
      );
    } else {
      // Group does not exist, create new group and add it to the TOP of the main list
      final newGroup = DailyNotificationGroup(
        dateLabel: todayLabel,
        alerts: [newAlert],
      );
      updatedState.insert(0, newGroup); // Insert at top
    }

    state = updatedState;
  }

  // Method to clear only dynamic (test) data
  void clearDynamicNotifications() {
    // 1. Iterate through groups
    // 2. Filter alerts to keep only non-dynamic ones
    // 3. Filter groups to remove empty groups
    state = state
        .map((group) {
          final filteredAlerts = group.alerts.where((alert) => !alert.isDynamic).toList();
          return DailyNotificationGroup(
            dateLabel: group.dateLabel,
            alerts: filteredAlerts,
          );
        })
        .where((group) => group.alerts.isNotEmpty)
        .toList();
  }
}

// The global provider
final notificationProvider = NotifierProvider<NotificationNotifier, List<DailyNotificationGroup>>(() {
  return NotificationNotifier();
});