import 'package:pak_tani/src/features/notification/data/models/notification_item_model.dart';

/// Abstract datasource interface for remote notification operations.
///
/// Implementations should perform network calls to fetch notification data
/// and expose methods to mark notifications as read (single and all).
abstract class NotificationRemoteDatasource {
  /// Fetches all notifications from the remote API and returns a list of
  /// `NotificationItemModel`, or `null` if no data is available.
  Future<List<NotificationItemModel>?> getListAllNotifications();

  /// Marks a single notification (by string `id`) as read and returns the
  /// updated `NotificationItemModel`.
  Future<NotificationItemModel> markReadNotification(String id);

  /// Marks all notifications as read on the remote side.
  Future<void> markAllNotifications();
}
