import 'package:pak_tani/src/features/notification/domain/entities/notification_item.dart';
import 'package:pak_tani/src/features/notification/domain/value_objects/notification_type.dart';

class NotificationItemModel extends NotificationItem {
  const NotificationItemModel({
    required super.id,
    required super.title,
    required super.message,
    required super.readStatus,
    required super.notificationType,
    required super.createdAt,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: json["id"],
      title: json["title"],
      message: json["body"],
      readStatus: json["read"],
      notificationType: NotificationType.fromJson(
        json["type"],
        defaultValue: NotificationType.system,
      )!,
      createdAt: DateTime.parse(json["created_at"]).toLocal(),
    );
  }

  factory NotificationItemModel.fromEntity(NotificationItem notificationItem) {
    return NotificationItemModel(
      id: notificationItem.id,
      title: notificationItem.title,
      message: notificationItem.message,
      readStatus: notificationItem.readStatus,
      notificationType: notificationItem.notificationType,
      createdAt: notificationItem.createdAt,
    );
  }

  NotificationItem toEntity() {
    return NotificationItem(
      id: id,
      title: title,
      message: message,
      readStatus: readStatus,
      notificationType: notificationType,
      createdAt: createdAt,
    );
  }
}
