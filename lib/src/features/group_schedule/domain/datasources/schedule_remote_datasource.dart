import 'package:pak_tani/src/features/group_schedule/data/models/schedule_model.dart';

abstract class ScheduleRemoteDatasource {
  Future<List<ScheduleModel>?> getListScheduleInGroup(String groupId);
  Future<ScheduleModel> addScheduleInGroup(
    String groupId, {
    required String time,
    int? duration,
    bool? repeatMonday,
    bool? repeatTuesday,
    bool? repeatWednesday,
    bool? repeatThursday,
    bool? repeatFriday,
    bool? repeatSaturday,
    bool? repeatSunday,
  });
  Future<ScheduleModel> editScheduleInGroup(
    String id, {
    String? time,
    int? duration,
    bool? isActive,
    bool? repeatMonday,
    bool? repeatTuesday,
    bool? repeatWednesday,
    bool? repeatThursday,
    bool? repeatFriday,
    bool? repeatSaturday,
    bool? repeatSunday,
  });
  Future<void> deleteSchedule(String id);
}
