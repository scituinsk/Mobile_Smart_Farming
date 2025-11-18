import 'package:pak_tani/src/features/group_schedule/domain/entities/schedule.dart';

abstract class ScheduleRepository {
  Future<List<Schedule>?> getListSchedule(int groupId);
  Future<Schedule> addSchedule(
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
  Future<Schedule> editSchedule(
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
