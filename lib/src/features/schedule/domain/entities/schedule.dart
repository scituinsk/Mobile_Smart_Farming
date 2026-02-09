import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

  List<String> getActiveDayCodes() {
    final codes = <String>[];
    if (repeatMonday) codes.add('mon');
    if (repeatTuesday) codes.add('tue');
    if (repeatWednesday) codes.add('wed');
    if (repeatThursday) codes.add('thu');
    if (repeatFriday) codes.add('fri');
    if (repeatSaturday) codes.add('sat');
    if (repeatSunday) codes.add('sun');
    return codes;
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
