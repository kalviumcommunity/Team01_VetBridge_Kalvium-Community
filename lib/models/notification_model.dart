// TODO: Replace mockNotifications with a real Firestore `notifications` collection query,
// filtered by user/branch. Use a real-time listener (e.g. StreamBuilder or a provider
// listening to Firestore snapshots) so that the bell badge count updates live whenever
// the server pushes new notifications.

/// The category of a clinic notification, used to select icon and colour.
enum NotificationType {
  /// A patient follow-up is due today or overdue.
  followUpDue,

  /// A vaccination booster or first dose is coming due soon.
  vaccinationDue,

  /// An appointment has been confirmed, rescheduled, or cancelled.
  appointmentUpdate,
}

/// A single in-app notification entry.
class AppNotification {
  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;

  /// Returns a copy of this notification with [isRead] toggled to true.
  AppNotification markRead() => AppNotification(
        id: id,
        type: type,
        title: title,
        message: message,
        timestamp: timestamp,
        isRead: true,
      );
}

// Mock data — timestamps are relative to DateTime.now() so that the
// relative-time formatter always has realistic data to render.
final mockNotifications = <AppNotification>[
  AppNotification(
    id: 'notif-001',
    type: NotificationType.followUpDue,
    title: "Buddy's follow-up is due today",
    message: 'John Smith — Skin follow-up scheduled for today. Please review before the appointment.',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    isRead: false,
  ),
  AppNotification(
    id: 'notif-002',
    type: NotificationType.vaccinationDue,
    title: "Luna's rabies booster due in 3 days",
    message: 'Priya Sharma — Rabies booster (3-year) due 19 Sep 2026. Consider scheduling now.',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    isRead: false,
  ),
  AppNotification(
    id: 'notif-003',
    type: NotificationType.appointmentUpdate,
    title: 'Appointment confirmed — Milo',
    message: "Kavya Reddy's appointment with Dr. Meera Pillai at Central Clinic is confirmed for today at 14:00.",
    timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    isRead: false,
  ),
  AppNotification(
    id: 'notif-004',
    type: NotificationType.vaccinationDue,
    title: "Max's annual vaccination due",
    message: 'Arjun Nair — Annual vaccination package for Max is due next week. Schedule now to avoid a lapse.',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    isRead: true,
  ),
];

/// Formats a [DateTime] as a human-readable relative time string.
///
/// Examples: "Just now", "5m ago", "2h ago", "Yesterday", "14 Sep 2026".
String formatRelativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);

  if (diff.inSeconds < 60) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';

  // Check if it was yesterday.
  final today = DateTime(now.year, now.month, now.day);
  final dayOfTimestamp = DateTime(dateTime.year, dateTime.month, dateTime.day);
  if (today.difference(dayOfTimestamp).inDays == 1) return 'Yesterday';

  // Fall back to a short calendar date for anything older.
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
}
