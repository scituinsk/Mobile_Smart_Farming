import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/features/schedule/domain/value_objects/week_day.dart';

class Schedule extends Equatable {
  final int id;
  final int groupId;
  final int? duration;
  final TimeOfDay time;
  final bool isActive;
  final bool repeatMonday;
  final bool repeatTuesday;
  final bool repeatWednesday;
  final bool repeatThursday;
  final bool repeatFriday;
  final bool repeatSaturday;
  final bool repeatSunday;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Schedule({
    required this.id,
    required this.groupId,
    this.duration,
    required this.time,
    required this.isActive,
    required this.repeatMonday,
    required this.repeatTuesday,
    required this.repeatWednesday,
    required this.repeatThursday,
    required this.repeatFriday,
    required this.repeatSaturday,
    required this.repeatSunday,
    required this.createdAt,
    required this.updatedAt,
  });

  String getActiveDays() {
    final activeDays = <String>[];
    if (repeatMonday) activeDays.add(WeekDay.mon.short);
    if (repeatTuesday) activeDays.add(WeekDay.tue.short);
    if (repeatWednesday) activeDays.add(WeekDay.wed.short);
    if (repeatThursday) activeDays.add(WeekDay.thu.short);
    if (repeatFriday) activeDays.add(WeekDay.fri.short);
    if (repeatSaturday) activeDays.add(WeekDay.sat.short);
    if (repeatSunday) activeDays.add(WeekDay.sun.short);

    if (activeDays.isEmpty) return 'schedule_no_repeat'.tr;
    if (activeDays.length == 7) return 'schedule_every_day'.tr;
    return activeDays.join(', ');
  }

  String getFormattedTime() {
    final hour = time.hour.toString().padLeft(2, "0");
    final minute = time.minute.toString().padLeft(2, "0");
    return "$hour:$minute";
  }

  @override
  List<Object?> get props => [
    id,
    groupId,
    duration,
    time,
    isActive,
    repeatMonday,
    repeatTuesday,
    repeatWednesday,
    repeatThursday,
    repeatFriday,
    repeatSaturday,
    repeatSunday,
    createdAt,
    updatedAt,
  ];
}
