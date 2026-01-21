import 'package:pak_tani/src/features/notification/data/models/notification_item_model.dart';

abstract class NotificationRemoteDatasource {
  Future<List<NotificationItemModel>?> getListAllNotifications();
  Future<NotificationItemModel> markReadNotification(String id);
  Future<void> markAllNotifications();
}
