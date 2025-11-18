import 'package:equatable/equatable.dart';

class Schedule extends Equatable {
  final int id;
  final int groupId;
  final int? duration;
  final String time;
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
