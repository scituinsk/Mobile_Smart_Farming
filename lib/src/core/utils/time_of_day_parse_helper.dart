/// A utility class for parsing and formatting TimeOfDay objects.
/// This class povides static methods o convert between string representations and TimeOfDay,
/// handling local and UTC time conversions for accurate time management in the app.

library;

import 'package:flutter/material.dart';

/// A helper class for TimeOfDay parsing and formatting utilities.
/// Contains methods to parse strings into TimeOfDay, format TimeOfDay to strings,
/// and convert TimeOfDay to UTC strings.
class TimeOfDayParseHelper {
  /// Parses a time string with format HH:MM into a TimeOfDay object.
  /// [timeString] is in UTC time and convert to local time.
  /// Defaults to 00:00 if parsing fails.
  /// This function usually used to convert json response to TimeOfDay.
  static TimeOfDay parseTimeOfDay(String timeString) {
    final parts = timeString.split(":");
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    final now = DateTime.now();
    final utcDt = DateTime.utc(now.year, now.month, now.day, hour, minute);
    final localDt = utcDt.toLocal();
    return TimeOfDay(hour: localDt.hour, minute: localDt.minute);
  }

  ///Formats a TimeOfDay into a string with format "HH:MM".
  ///Pads hours and minutes with leading zeros.
  ///Used to visualize TimeOfDay to user.
  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, "0");
    final minute = time.minute.toString().padLeft(2, "0");
    return "$hour:$minute";
  }

  /// Convert a TimeOfDay to a UTC time string with format "HH:MM".
  /// TimeOfDay is in local time and converts it to UTC.
  /// Pads hours and minutes with leading zeros.
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
