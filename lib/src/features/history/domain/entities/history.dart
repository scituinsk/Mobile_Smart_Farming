import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pak_tani/src/features/history/domain/value_objects/history_type.dart';
import 'package:pak_tani/src/features/history/domain/entities/schedule_history.dart';

class History extends Equatable {
  final int id;
  final int modulId;
  final int? scheduleGroupId;
  final HistoryType? historyType;
  final String? name;
  final TimeOfDay? alarmTime;
  final List<ScheduleHistory>? scheduleHistories;
  final String? message;
  final DateTime createdAt;
  final DateTime updatedAt;
  const History({
    required this.id,
    required this.modulId,
    this.scheduleGroupId,
    this.historyType,
    this.name,
    this.alarmTime,
    this.scheduleHistories,
    this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    modulId,
    historyType,
    name,
    alarmTime,
    scheduleHistories,
    message,
    createdAt,
    updatedAt,
  ];
}
