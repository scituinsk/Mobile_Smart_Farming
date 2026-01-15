import 'package:pak_tani/src/core/widgets/custom_icon.dart';

enum HistoryType {
  schedule("schedule", "schedule"),
  modul("modul", "modul");

  final String jsonValue;
  final String label;
  const HistoryType(this.jsonValue, this.label);

  static HistoryType? fromJson(String? value, {HistoryType? defaultValue}) {
    if (value == null) return defaultValue;
    return HistoryType.values.firstWhere(
      (element) =>
          element.jsonValue == value ||
          element.name == value ||
          element.label == value,
      orElse: () =>
          defaultValue ?? (throw StateError("Invalid HistoryType: $value")),
    );
  }

  static HistoryType? tryParse(String value) {
    return fromJson(value, defaultValue: null);
  }
}

extension HistoryTypeIcon on HistoryType {
  MyCustomIcon get icon {
    switch (this) {
      case HistoryType.modul:
        return MyCustomIcon.greenHouse;
      case HistoryType.schedule:
        return MyCustomIcon.calendarSync;
    }
  }
}
