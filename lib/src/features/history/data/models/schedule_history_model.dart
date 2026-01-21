import 'package:pak_tani/src/core/utils/time_of_day_parse_helper.dart';
import 'package:pak_tani/src/features/history/domain/entities/schedule_history.dart';

class ScheduleHistoryModel extends ScheduleHistory {
  const ScheduleHistoryModel({
    required super.startTime,
    required super.endTime,
    required super.pinName,
  });

  factory ScheduleHistoryModel.fromJson(Map<String, dynamic> json) {
    return ScheduleHistoryModel(
      startTime: TimeOfDayParseHelper.parseTimeOfDay(json["start"]),
      endTime: TimeOfDayParseHelper.parseTimeOfDay(json["end"]),
      pinName: json["pin"],
    );
  }

  factory ScheduleHistoryModel.fromEntity(ScheduleHistory scheduleHistory) {
    return ScheduleHistoryModel(
      endTime: scheduleHistory.endTime,
      startTime: scheduleHistory.startTime,
      pinName: scheduleHistory.pinName,
    );
  }

  ScheduleHistory toEntity() {
    return ScheduleHistory(
      startTime: startTime,
      endTime: endTime,
      pinName: pinName,
    );
  }
}
