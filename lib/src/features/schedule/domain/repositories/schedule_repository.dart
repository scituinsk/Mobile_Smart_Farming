import 'package:pak_tani/src/features/schedule/domain/entities/schedule.dart';

abstract class ScheduleRepository {
  Future<List<Schedule>?> getListSchedule(String groupId);
  Future<Schedule> addSchedule(
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
  Future<Schedule> editSchedule(
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
