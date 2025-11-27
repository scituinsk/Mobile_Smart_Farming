import 'package:pak_tani/src/core/widgets/custom_icon.dart';

enum RelayType {
  solenoid("solenoid", "Solenoid"),
  waterPump("water_pump", "Water Pump"),
  lamp("lamp", "Lampu");

  final String jsonValue;
  final String label;
  const RelayType(this.jsonValue, this.label);

  String get display => label;
  String get toJson => jsonValue;

  //convert from json/string to RelayType
  static RelayType? fromJson(String? value, {RelayType? defaultValue}) {
    if (value == null) return defaultValue;
    return RelayType.values.firstWhere(
      (element) =>
          element.jsonValue == value ||
          element.name == value ||
          element.label == value,
      orElse: () =>
          defaultValue ?? (throw StateError("Invalid RelayType: $value")),
    );
  }

  //safe parse: return null when non matched
  static RelayType? tryParse(String value) {
    return fromJson(value, defaultValue: null);
  }
}

extension RelayTypeLabel on RelayType {
  MyCustomIcon get icon {
    switch (this) {
      case RelayType.solenoid:
        return MyCustomIcon.waterDrop;
      case RelayType.waterPump:
        return MyCustomIcon.waterPump;
      case RelayType.lamp:
        return MyCustomIcon.lightBulb;
    }
  }
}
