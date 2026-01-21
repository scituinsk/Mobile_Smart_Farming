import 'package:equatable/equatable.dart';
import 'package:pak_tani/src/features/notification/domain/value_objects/notification_type.dart';

/// Domain entity that represents a single notification.
///
/// Contains canonical notification fields used throughout the application
/// layers: identifier, title, body message, read status, notification type
/// and creation timestamp. The entity is immutable and supports value
/// comparisons via `Equatable`.
class NotificationItem extends Equatable {
  /// Unique identifier for the notification.
  final int id;

  /// Short title or heading for the notification.
  final String title;

  /// Full message/body text for the notification.
  final String message;

  /// Whether the notification has been marked as read.
  final bool readStatus;

  /// Semantic type of the notification (e.g., system, promo, order).
  final NotificationType notificationType;

  /// When the notification was created (local `DateTime`).
  final DateTime createdAt;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.readStatus,
    required this.notificationType,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    message,
    readStatus,
    notificationType,
    createdAt,
  ];

  /// Returns a copy of this entity with any provided fields replaced.
  ///
  /// Useful to create updated instances (for example to change `readStatus`).
  NotificationItem copyWith({
    int? id,
    String? title,
    String? message,
    bool? readStatus,
    NotificationType? notificationType,
    DateTime? createdAt,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      readStatus: readStatus ?? this.readStatus,
      notificationType: notificationType ?? this.notificationType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
