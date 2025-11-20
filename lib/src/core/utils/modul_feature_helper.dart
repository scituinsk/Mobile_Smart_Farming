import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/features/modul/domain/entities/feature_data.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul_feature.dart';

class ModulFeatureHelper {
  static MyCustomIcon getFeatureIcon(String? featureName) {
    switch (featureName?.toLowerCase()) {
      case 'temperature':
        return MyCustomIcon.temprature;
      case "water_level":
        return MyCustomIcon.waterLevel;
      case 'humidity':
        return MyCustomIcon.waterPH;
      case "schedule":
        return MyCustomIcon.calendar;
      default:
        return MyCustomIcon.solenoid;
    }
  }

  static String getFeatureName(String? featureName) {
    switch (featureName?.toLowerCase()) {
      case 'temperature':
        return "Temperature";
      case "water_level":
        return "Water level";
      case 'humidity':
        return "Humidity";
      case "schedule":
        return "Penjadwalan";
      default:
        return "undifined";
    }
  }

  static FeatureData? getFeatureData(String? featureName, FeatureData data) {
    switch (featureName?.toLowerCase()) {
      case 'temperature':
        return FeatureData(name: data.name, data: "${data.data}°C");
      case "water_level":
        return FeatureData(name: data.name, data: "${data.data}%");
      case 'humidity':
        return FeatureData(name: data.name, data: "${data.data}%");
      case "schedule":
        return data;
      default:
        return FeatureData(name: "undifined", data: "undifined");
    }
  }

  static int? getBatteryValue(ModulFeature? batteryFeature) {
    if (batteryFeature == null ||
        batteryFeature.data == null ||
        batteryFeature.data!.isEmpty) {
      return null;
    }

    // Ambil data pertama dari list
    final firstBatteryData = batteryFeature.data!.first;

    // Convert data ke int
    if (firstBatteryData.data is int) {
      return firstBatteryData.data as int;
    } else if (firstBatteryData.data is String) {
      return int.tryParse(firstBatteryData.data as String);
    } else if (firstBatteryData.data is double) {
      return (firstBatteryData.data as double).toInt();
    }

    return null;
  }

  static Color getFeatureColor(String? featureName) {
    switch (featureName?.toLowerCase()) {
      case 'temperature':
        return AppTheme.temperatureColor;
      case "water_level":
        return AppTheme.waterLevelColor;
      case 'humidity':
        return AppTheme.humidityColor;
      default:
        return AppTheme.primaryColor;
    }
  }
}
