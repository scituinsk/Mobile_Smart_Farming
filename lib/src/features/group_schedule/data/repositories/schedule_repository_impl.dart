import 'package:pak_tani/src/features/group_schedule/domain/datasources/schedule_remote_datasource.dart';
import 'package:pak_tani/src/features/group_schedule/domain/entities/schedule.dart';
import 'package:pak_tani/src/features/group_schedule/domain/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl extends ScheduleRepository {
  final ScheduleRemoteDatasource _remoteDatasource;

  ScheduleRepositoryImpl(this._remoteDatasource);

  @override
  Future<List<Schedule>?> getListSchedule(String groupId) async {
    try {
      final listSchedule = await _remoteDatasource.getListScheduleInGroup(
        groupId,
      );
      if (listSchedule != null) {
        return listSchedule.map((schedule) => schedule.toEntity()).toList();
      }
      return null;
    } catch (e) {
      print("Error get list schedule(repository): $e");
      rethrow;
    }
  }

  @override
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
  }) async {
    try {
      final schedule = await _remoteDatasource.addScheduleInGroup(
        groupId,
        time: time,
        duration: duration,
        repeatMonday: repeatMonday,
        repeatTuesday: repeatTuesday,
        repeatWednesday: repeatWednesday,
        repeatThursday: repeatThursday,
        repeatFriday: repeatFriday,
        repeatSaturday: repeatSaturday,
        repeatSunday: repeatSunday,
      );

      return schedule.toEntity();
    } catch (e) {
      print("error add schedule: $e");
      rethrow;
    }
  }

  @override
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
  }) async {
    try {
      final schedule = await _remoteDatasource.editScheduleInGroup(
        id,
        time: time,
        duration: duration,
        isActive: isActive,
        repeatMonday: repeatMonday,
        repeatTuesday: repeatTuesday,
        repeatWednesday: repeatWednesday,
        repeatThursday: repeatThursday,
        repeatFriday: repeatFriday,
        repeatSaturday: repeatSaturday,
        repeatSunday: repeatSunday,
      );

      return schedule.toEntity();
    } catch (e) {
      print("error edit schedule(repo): $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteSchedule(String id) async {
    try {
      await _remoteDatasource.deleteSchedule(id);
    } catch (e) {
      print("error deleting schedule(repo): $e");
      rethrow;
    }
  }
}
