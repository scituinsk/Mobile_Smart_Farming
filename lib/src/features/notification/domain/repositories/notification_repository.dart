import 'package:pak_tani/src/features/notification/domain/entities/notification_item.dart';

/// Repository interface for notification operations used by domain layers.
///
/// Implementations are responsible for providing access to notification
/// data (e.g., remote or local sources) and must implement methods to fetch
/// the list of notifications and to mark notifications as read.
abstract class NotificationRepository {
  /// Returns a list of all notifications, or `null` if none are available.
  Future<List<NotificationItem>?> getListAllNotifications();

  /// Marks all notifications as read.
  Future<void> markReadAllNotifications();

  /// Marks a single notification as read and returns the updated entity.
  Future<NotificationItem> markReadNotification(int id);
}
