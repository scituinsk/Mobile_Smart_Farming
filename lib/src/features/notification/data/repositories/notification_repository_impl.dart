import 'package:pak_tani/src/features/notification/domain/datasources/notification_remote_datasource.dart';
import 'package:pak_tani/src/features/notification/domain/entities/notification_item.dart';
import 'package:pak_tani/src/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationRemoteDatasource _remoteDatasource;
  NotificationRepositoryImpl(this._remoteDatasource);

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

  @override
  Future<void> markReadAllNotifications() async {
    try {
      await _remoteDatasource.markAllNotifications();
    } catch (e) {
      print("Error mark read all notifications(repo): $e");
      rethrow;
    }
  }

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
