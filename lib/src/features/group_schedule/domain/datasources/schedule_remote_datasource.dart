import 'package:pak_tani/src/features/group_schedule/data/models/schedule_model.dart';

abstract class ScheduleRemoteDatasource {
  Future<List<ScheduleModel>?> getListScheduleInGroup(int groupId);
  Future<ScheduleModel> addScheduleInGroup(
    int groupId, {
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
    int id,
    int groupId, {
    String? time,
    int? duration,
    bool? repeatMonday,
    bool? repeatTuesday,
    bool? repeatWednesday,
    bool? repeatThursday,
    bool? repeatFriday,
    bool? repeatSaturday,
    bool? repeatSunday,
  });
  Future<void> deleteSchedule(int id);
}
