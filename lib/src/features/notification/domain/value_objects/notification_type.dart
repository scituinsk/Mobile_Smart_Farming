import 'package:pak_tani/src/core/utils/custom_icon.dart';

enum NotificationType {
  schedule("schedule", "penjadwalan"),
  modul("modul", "modul"),
  system("system", "sistem"),
  batteryMax("battery_max", "baterai penuh"),
  batteryLow("battery_low", "baterai habis");

  final String jsonValue;
  final String label;
  const NotificationType(this.jsonValue, this.label);

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

  static NotificationType? tryParse(String value) {
    return fromJson(value, defaultValue: null);
  }
}

extension HistoryTypeIcon on NotificationType {
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
