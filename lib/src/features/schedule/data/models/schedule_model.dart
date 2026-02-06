import 'package:pak_tani/src/core/utils/time_parser_helper.dart';
import 'package:pak_tani/src/features/schedule/domain/entities/schedule.dart';

class ScheduleModel extends Schedule {
  const ScheduleModel({
    required super.id,
    required super.groupId,
    super.duration,
    required super.time,
    required super.isActive,
    required super.repeatMonday,
    required super.repeatTuesday,
    required super.repeatWednesday,
    required super.repeatThursday,
    required super.repeatFriday,
    required super.repeatSaturday,
    required super.repeatSunday,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json["id"],
      groupId: json["group"],
      duration: json["duration"],
      time: TimeParserHelper.parseTimeOfDay(json["time"] as String),
      isActive: json["is_active"],
      repeatMonday: json["repeat_monday"],
      repeatTuesday: json["repeat_tuesday"],
      repeatWednesday: json["repeat_wednesday"],
      repeatThursday: json["repeat_thursday"],
      repeatFriday: json["repeat_friday"],
      repeatSaturday: json["repeat_saturday"],
      repeatSunday: json["repeat_sunday"],
      createdAt: DateTime.parse(json["created_at"] as String),
      updatedAt: DateTime.parse(json["updated_at"] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "group": groupId,
      "duration": duration,
      "time": TimeParserHelper.formatTimeOfDay(time),
      "is_active": isActive,
      "repeat_monday": repeatMonday,
      "repeat_tuesday": repeatTuesday,
      "repeat_wednesday": repeatWednesday,
      "repeat_thursday": repeatThursday,
      "repeat_friday": repeatFriday,
      "repeat_saturday": repeatSaturday,
      "repeat_sunday": repeatSunday,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

  factory ScheduleModel.fromEntity(Schedule schedule) {
    return ScheduleModel(
      id: schedule.id,
      groupId: schedule.groupId,
      duration: schedule.duration,
      time: schedule.time,
      isActive: schedule.isActive,
      repeatMonday: schedule.repeatMonday,
      repeatTuesday: schedule.repeatTuesday,
      repeatWednesday: schedule.repeatWednesday,
      repeatThursday: schedule.repeatThursday,
      repeatFriday: schedule.repeatFriday,
      repeatSaturday: schedule.repeatSaturday,
      repeatSunday: schedule.repeatSunday,
      createdAt: schedule.createdAt,
      updatedAt: schedule.updatedAt,
    );
  }

  Schedule toEntity() {
    return Schedule(
      id: id,
      groupId: groupId,
      duration: duration,
      time: time,
      isActive: isActive,
      repeatMonday: repeatMonday,
      repeatTuesday: repeatTuesday,
      repeatWednesday: repeatWednesday,
      repeatThursday: repeatThursday,
      repeatFriday: repeatFriday,
      repeatSaturday: repeatSaturday,
      repeatSunday: repeatSunday,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
