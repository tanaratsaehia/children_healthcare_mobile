import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NotificationAlert {
  final String message;
  final bool isCritical;
  final bool isDynamic; // TRUE if it's test data, FALSE if it's original mockup data
  final String time; // HH:mm format

  NotificationAlert({
    required this.message,
    this.isCritical = true,
    this.isDynamic = false,
    this.time = '',
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

// PRE-FIX MOCKUP DATA (Original)
final List<DailyNotificationGroup> staticMockupData = [
  DailyNotificationGroup(
    dateLabel: "10 Oct. 2025",
    alerts: [
      NotificationAlert(message: "Bilirubin too high", time: "14:32"),
      NotificationAlert(message: "Oxygen too high", time: "09:15"),
      NotificationAlert(message: "Glucose too high", time: "21:47"),
    ],
  ),
  DailyNotificationGroup(
    dateLabel: "9 Oct. 2025",
    alerts: [
      NotificationAlert(message: "Oxygen too low", time: "07:22"),
    ],
  ),
  DailyNotificationGroup(
    dateLabel: "8 Oct. 2025",
    alerts: [
      NotificationAlert(message: "Bilirubin too high", time: "16:05"),
      NotificationAlert(message: "Oxygen too high", time: "11:38"),
    ],
  ),
];

// RIVERPOD NOTIFIER
class NotificationNotifier extends Notifier<List<DailyNotificationGroup>> {
  @override
  List<DailyNotificationGroup> build() {
    return staticMockupData;
  }

  void addTestNotification(String message) {
    final now = DateTime.now();
    final formatter = DateFormat('d MMM. yyyy'); // e.g., "2 May. 2026"
    final todayLabel = formatter.format(now);
    final timeLabel = DateFormat('HH:mm').format(now);

    final newAlert = NotificationAlert(
      message: message,
      isDynamic: true,
      time: timeLabel,
    );

    final List<DailyNotificationGroup> updatedState = List.from(state);
    int todayIndex = updatedState.indexWhere((group) => group.dateLabel == todayLabel);

    if (todayIndex != -1) {
      final currentGroup = updatedState[todayIndex];
      updatedState[todayIndex] = DailyNotificationGroup(
        dateLabel: currentGroup.dateLabel,
        alerts: [newAlert, ...currentGroup.alerts],
      );
    } else {
      final newGroup = DailyNotificationGroup(
        dateLabel: todayLabel,
        alerts: [newAlert],
      );
      updatedState.insert(0, newGroup); // Insert at top
    }

    state = updatedState;
  }

  void clearDynamicNotifications() {
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