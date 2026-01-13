import 'package:flutter/material.dart';

class TimeOfDayParseHelper {
  static TimeOfDay parseTimeOfDay(String timeString) {
    final parts = timeString.split(":");
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    final now = DateTime.now();
    final utcDt = DateTime.utc(now.year, now.month, now.day, hour, minute);
    final localDt = utcDt.toLocal();
    return TimeOfDay(hour: localDt.hour, minute: localDt.minute);
  }

  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, "0");
    final minute = time.minute.toString().padLeft(2, "0");
    return "$hour:$minute";
  }

  static String fromatTimeOfDayToUtcString(TimeOfDay time) {
    final now = DateTime.now();
    final localDt = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    final utcDt = localDt.toUtc();
    final hh = utcDt.hour.toString().padLeft(2, '0');
    final mm = utcDt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}
