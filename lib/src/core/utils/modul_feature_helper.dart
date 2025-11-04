import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';

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

  static String getFeatureData(String? featureName, String data) {
    switch (featureName?.toLowerCase()) {
      case 'temperature':
        return "$data°C";
      case "water_level":
        return "$data%";
      case 'humidity':
        return "$data%";
      case "schedule":
        return data;
      default:
        return "undifined";
    }
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
