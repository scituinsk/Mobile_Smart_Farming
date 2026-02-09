import 'package:get/get.dart';

enum WeekDay { mon, tue, wed, thu, fri, sat, sun }

extension WeekDayLabel on WeekDay {
  String get short {
    switch (this) {
      case WeekDay.mon:
        return 'weekday_mon_short'.tr;
      case WeekDay.tue:
        return 'weekday_tue_short'.tr;
      case WeekDay.wed:
        return 'weekday_wed_short'.tr;
      case WeekDay.thu:
        return 'weekday_thu_short'.tr;
      case WeekDay.fri:
        return 'weekday_fri_short'.tr;
      case WeekDay.sat:
        return 'weekday_sat_short'.tr;
      case WeekDay.sun:
        return 'weekday_sun_short'.tr;
    }
  }

  String get long {
    switch (this) {
      case WeekDay.mon:
        return 'weekday_mon_long'.tr;
      case WeekDay.tue:
        return 'weekday_tue_long'.tr;
      case WeekDay.wed:
        return 'weekday_wed_long'.tr;
      case WeekDay.thu:
        return 'weekday_thu_long'.tr;
      case WeekDay.fri:
        return 'weekday_fri_long'.tr;
      case WeekDay.sat:
        return 'weekday_sat_long'.tr;
      case WeekDay.sun:
        return 'weekday_sun_long'.tr;
    }
  }
}

Set<WeekDay> getSelectedWeekDays({
  required bool mon,
  required bool tue,
  required bool wed,
  required bool thu,
  required bool fri,
  required bool sat,
  required bool sun,
}) {
  final selected = <WeekDay>{};
  if (mon) selected.add(WeekDay.mon);
  if (tue) selected.add(WeekDay.tue);
  if (wed) selected.add(WeekDay.wed);
  if (thu) selected.add(WeekDay.thu);
  if (fri) selected.add(WeekDay.fri);
  if (sat) selected.add(WeekDay.sat);
  if (sun) selected.add(WeekDay.sun);
  return selected;
}
