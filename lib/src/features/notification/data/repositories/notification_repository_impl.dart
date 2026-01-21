import 'package:pak_tani/src/features/notification/domain/datasources/notification_remote_datasource.dart';
import 'package:pak_tani/src/features/notification/domain/entities/notification_item.dart';
import 'package:pak_tani/src/features/notification/domain/repositories/notification_repository.dart';

/// Concrete implementation of [NotificationRepository].
///
/// Bridges the domain-level repository interface to a remote datasource
/// (`NotificationRemoteDatasource`). Responsible for converting remote
/// models into domain entities and forwarding read operations to the
/// datasource while handling errors.
class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationRemoteDatasource _remoteDatasource;
  NotificationRepositoryImpl(this._remoteDatasource);

  /// Retrieves the full list of notifications from the remote datasource
  /// and converts each `NotificationItemModel` into the domain
  /// `NotificationItem` entity.
  @override
  Future<List<NotificationItem>?> getListAllNotifications() async {
    try {
      final listNotifications = await _remoteDatasource
          .getListAllNotifications();
      if (listNotifications != null) {
        return listNotifications
            .map((notificationItems) => notificationItems.toEntity())
            .toList();
      }
      return null;
    } catch (e) {
      print("Error get list all notification(repo): $e");
      rethrow;
    }
  }

  /// Marks all notifications as read via the remote datasource.
  @override
  Future<void> markReadAllNotifications() async {
    try {
      await _remoteDatasource.markAllNotifications();
    } catch (e) {
      print("Error mark read all notifications(repo): $e");
      rethrow;
    }
  }

  /// Marks a single notification as read by forwarding the call to the
  /// remote datasource and converting the returned model to the domain
  /// entity.
  @override
  Future<NotificationItem> markReadNotification(int id) async {
    try {
      final notificationItem = await _remoteDatasource.markReadNotification(
        id.toString(),
      );
      return notificationItem.toEntity();
    } catch (e) {
      print("Error mark read notification: $e");
      rethrow;
    }
  }
}
