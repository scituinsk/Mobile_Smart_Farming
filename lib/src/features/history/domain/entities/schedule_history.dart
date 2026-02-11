import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ScheduleHistory extends Equatable {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String pinName;
  const ScheduleHistory({
    required this.startTime,
    required this.endTime,
    required this.pinName,
  });

  @override
  List<Object?> get props => [startTime, endTime, pinName];

  @override
  String toString() {
    return "ScheduleHistory(startTime: $startTime, endTime: $endTime, pinName: $pinName)";
  }
}
