import 'package:pak_tani/src/core/utils/custom_icon.dart';

/// Value object representing the semantic type of a notification.
///
/// Each enum value carries a `jsonValue` used when serializing/deserializing
/// from API payloads and a human-readable `label`. Utility constructors
/// help parse external values safely.
enum NotificationType {
  schedule("schedule", "penjadwalan"),
  modul("modul", "modul"),
  system("system", "sistem"),
  batteryMax("battery_max", "baterai penuh"),
  batteryLow("battery_low", "baterai habis");

  /// The value used in JSON payloads for this type.
  final String jsonValue;

  /// A localized or display label for the type.
  final String label;

  const NotificationType(this.jsonValue, this.label);

  /// Parses a string into a [NotificationType].
  ///
  /// Accepts matching by `jsonValue`, enum `name`, or `label`. If [value]
  /// is `null`, the provided [defaultValue] is returned. If parsing fails
  /// and no [defaultValue] is provided, a [StateError] is thrown.
  static NotificationType? fromJson(
    String? value, {
    NotificationType? defaultValue,
  }) {
    if (value == null) return defaultValue;
    return NotificationType.values.firstWhere(
      (element) =>
          element.jsonValue == value ||
          element.name == value ||
          element.label == value,
      orElse: () =>
          defaultValue ?? (throw StateError("Invalid HistoryType: $value")),
    );
  }

  /// Attempts to parse [value] into a [NotificationType]. Returns `null` if
  /// parsing fails.
  static NotificationType? tryParse(String value) {
    return fromJson(value, defaultValue: null);
  }
}

/// Extension providing a UI icon for each [NotificationType].
///
/// Maps semantic notification types to an application-specific
/// `MyCustomIcon` so presentation code can easily render an icon for a
/// given notification.
extension HistoryTypeIcon on NotificationType {
  /// Returns the corresponding icon for this notification type.
  MyCustomIcon get icon {
    switch (this) {
      case NotificationType.modul:
        return MyCustomIcon.greenHouse;
      case NotificationType.schedule:
        return MyCustomIcon.calendar;
      case NotificationType.system:
        return MyCustomIcon.server;
      case NotificationType.batteryMax:
        return MyCustomIcon.batteryMax;
      case NotificationType.batteryLow:
        return MyCustomIcon.batteryLow;
    }
  }
}
