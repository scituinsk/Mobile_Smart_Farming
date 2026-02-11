/// A utility class that provides helper methods for handling module features.
/// This class contains static methods to retrive icons, names, data formatting, and colors
/// based on feature names, supporting modul features like temrature, water level, humidity, and scheduling.

library;

import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';
import 'package:pak_tani/src/features/modul/domain/entities/feature_data.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul_feature.dart';

/// A helper class for module feature utilities.
/// Provides method to map feature names to icon, display names, formatted data, and colors.
class ModulFeatureHelper {
  /// Returns the appropriate custom icon for the given feature name.
  ///
  /// - 'temprature' -> MyCustomIcon.temprature;
  /// - 'water_level' -> MyCustomIcon.waterLevel;
  /// - 'humidity' ->  MyCustomIcon.waterPH;
  /// - 'schedule' -> MyCustomIcon.calendar;
  /// - default -> MyCustomIcon.solenoid;
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

  ///Returns the display name for the given feature name.
  ///
  /// - 'temprature' -> "Temprature";
  /// - 'water_level' -> "Water level";
  /// - 'humidity' ->  "Humidity";
  /// - 'schedule' -> "Penjadwalan";
  /// - default -> "undifined";
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

  /// Fromats and return the feature data based on the feature name.
  /// Adds units °C or % where applicable.
  ///
  /// - "temperature" -> Appends "°C"
  /// - "water_level" and "humidity" -> Appends "%"
  /// - "schedule" -> Returns data as-is
  /// - Default -> Returns a default "undifined" FeatureData
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

  /// Extracts the battery value from the given ModuleFeature.
  /// Attempts to convert the first data entry to an integer.
  /// Returns null if data is unavailable or conversion fails.
  static int? getBatteryValue(ModulFeature? batteryFeature) {
    if (batteryFeature == null ||
        batteryFeature.data == null ||
        batteryFeature.data!.isEmpty) {
      return null;
    }

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

  /// Returns the color associated with the given feature name.
  ///
  /// - "temprature" -> AppTheme.temperatureColor
  /// - "water_level" -> AppTheme.waterLevelColor
  /// - "humidity" -> AppTheme.humidityColor
  /// - default -> AppTheme.primaryColor
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
