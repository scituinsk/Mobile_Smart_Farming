import 'package:pak_tani/src/features/notification/domain/entities/notification_item.dart';

abstract class NotificationRepository {
  Future<List<NotificationItem>?> getListAllNotifications();
  Future<void> markReadAllNotifications();
  Future<NotificationItem> markReadNotification(int id);
}
