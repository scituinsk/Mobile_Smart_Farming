import 'package:pak_tani/src/features/notification/domain/entities/notification_item.dart';
import 'package:pak_tani/src/features/notification/domain/value_objects/notification_type.dart';

/// Data model representing a notification returned by remote APIs.
///
/// Extends the domain `NotificationItem` entity and provides JSON
/// serialization helpers for mapping network payloads into domain-safe
/// objects.
class NotificationItemModel extends NotificationItem {
  /// Creates a [NotificationItemModel] from explicit fields.
  const NotificationItemModel({
    required super.id,
    required super.title,
    required super.message,
    required super.readStatus,
    required super.notificationType,
    required super.createdAt,
  });

  /// Creates a [NotificationItemModel] from a JSON map returned by the API.
  ///
  /// Expects the JSON to contain keys like `id`, `title`, `body`, `read`,
  /// `type` and `created_at`. The `type` field is converted using
  /// `NotificationType.fromJson` and `created_at` is parsed into a
  /// `DateTime` (converted to local time).
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

  /// Creates a model from an existing domain `NotificationItem` entity.
  ///
  /// Useful when converting domain objects back to a transport-friendly
  /// representation or when preparing local fixtures in tests.
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

  /// Converts this model back into the domain `NotificationItem` entity.
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
