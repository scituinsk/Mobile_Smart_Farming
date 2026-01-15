import 'package:pak_tani/src/core/utils/time_of_day_parse_helper.dart';
import 'package:pak_tani/src/features/history/data/models/schedule_history_model.dart';
import 'package:pak_tani/src/features/history/domain/entities/history.dart';
import 'package:pak_tani/src/features/history/domain/entities/schedule_history.dart';
import 'package:pak_tani/src/features/history/domain/value_objects/history_type.dart';

class HistoryModel extends History {
  const HistoryModel({
    required super.id,
    required super.modulId,
    super.historyType,
    super.name,
    super.alarmTime,
    super.scheduleHistories,
    super.message,
    required super.createdAt,
    required super.updatedAt,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json["id"],
      modulId: json["module"],
      historyType: HistoryType.fromJson(json["type"]),
      name: json["name"],
      message: json["data"]["message"],
      alarmTime: TimeOfDayParseHelper.parseTimeOfDay(json["alarm_at"]),
      scheduleHistories: json["data"]["pins"] != null
          ? (json["data"]["pins"] as List<dynamic>)
                .map(
                  (scheduleHistory) => ScheduleHistoryModel.fromJson(
                    scheduleHistory as Map<String, dynamic>,
                  ),
                )
                .cast<ScheduleHistory>()
                .toList()
          : null,
      createdAt: DateTime.parse(json["created_at"]).toLocal(),
      updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
    );
  }

  factory HistoryModel.fromEntity(History history) {
    return HistoryModel(
      id: history.id,
      modulId: history.modulId,
      alarmTime: history.alarmTime,
      name: history.name,
      historyType: history.historyType,
      message: history.message,
      scheduleHistories: history.scheduleHistories,
      createdAt: history.createdAt,
      updatedAt: history.updatedAt,
    );
  }

  History toEntity() {
    return History(
      id: id,
      modulId: modulId,
      alarmTime: alarmTime,
      name: name,
      historyType: historyType,
      scheduleHistories: scheduleHistories,
      message: message,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
