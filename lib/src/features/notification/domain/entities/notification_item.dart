import 'package:equatable/equatable.dart';
import 'package:pak_tani/src/features/notification/domain/value_objects/notification_type.dart';

class NotificationItem extends Equatable {
  final int id;
  final String title;
  final String message;
  final bool readStatus;
  final NotificationType notificationType;
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
