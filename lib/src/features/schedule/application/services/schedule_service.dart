import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/utils/time_of_day_parse_helper.dart';
import 'package:pak_tani/src/core/widgets/my_snackbar.dart';
import 'package:pak_tani/src/features/schedule/domain/entities/schedule.dart';
import 'package:pak_tani/src/features/schedule/domain/repositories/schedule_repository.dart';

class ScheduleService extends GetxService {
  final ScheduleRepository _repository;
  ScheduleService(this._repository);

  final RxBool isFetching = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isDeleting = false.obs;

  final RxList<Schedule> schedules = <Schedule>[].obs;
  final Rx<Schedule?> selectedSchedules = Rx<Schedule?>(null);

  Future<void> loadSchedules(int groupId) async {
    isFetching.value = true;
    try {
      final scheduleList = await _repository.getListSchedule(
        groupId.toString(),
      );
      if (scheduleList != null) {
        schedules.assignAll(scheduleList);
        print("loaded schedule: ${scheduleList.length}");
      } else {
        schedules.clear();
        print("no schedules found");
      }
    } catch (e) {
      MySnackbar.error(message: e.toString());
      print("error loading schedules(service): $e");
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> addNewSchedule(
    int groupId, {
    required TimeOfDay time,
    int? duration,
    bool? repeatMonday,
    bool? repeatTuesday,
    bool? repeatWednesday,
    bool? repeatThursday,
    bool? repeatFriday,
    bool? repeatSaturday,
    bool? repeatSunday,
  }) async {
    isSaving.value = true;
    try {
      final timeParse = TimeOfDayParseHelper.formatTimeOfDay(time);
      final newSchedule = await _repository.addSchedule(
        groupId.toString(),
        time: timeParse,
        duration: duration,
        repeatMonday: repeatMonday,
        repeatTuesday: repeatTuesday,
        repeatWednesday: repeatWednesday,
        repeatThursday: repeatThursday,
        repeatFriday: repeatFriday,
        repeatSaturday: repeatSaturday,
        repeatSunday: repeatSunday,
      );

      schedules.add(newSchedule);
    } catch (e) {
      print("error add new schedule: $e");
      rethrow;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteSchedule(int id) async {
    isDeleting.value = true;
    try {
      await _repository.deleteSchedule(id.toString());
      schedules.removeWhere((element) => element.id == id);
    } catch (e) {
      print("error deleting schedule: $e");
      rethrow;
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> editSchedule(
    int id, {
    TimeOfDay? time,
    int? duration,
    bool? repeatMonday,
    bool? repeatTuesday,
    bool? repeatWednesday,
    bool? repeatThursday,
    bool? repeatFriday,
    bool? repeatSaturday,
    bool? repeatSunday,
  }) async {
    isSaving.value = true;
    try {
      String? timeParse;
      if (time != null) {
        timeParse = TimeOfDayParseHelper.formatTimeOfDay(time);
      }

      final editedSchedule = await _repository.editSchedule(
        id.toString(),
        time: timeParse,
        duration: duration,
        repeatMonday: repeatMonday,
        repeatTuesday: repeatTuesday,
        repeatWednesday: repeatWednesday,
        repeatThursday: repeatThursday,
        repeatFriday: repeatFriday,
        repeatSaturday: repeatSaturday,
        repeatSunday: repeatSunday,
      );

      final index = schedules.indexWhere(
        (element) => element.id == editedSchedule.id,
      );
      schedules[index] = editedSchedule;
    } catch (e) {
      print("Error editing schedule(service): $e");
      rethrow;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> editStatusSchedule(int id, bool isActive) async {
    try {
      final editedSchedule = await _repository.editSchedule(
        id.toString(),
        isActive: isActive,
      );

      final index = schedules.indexWhere(
        (element) => element.id == editedSchedule.id,
      );

      schedules[index] = editedSchedule;
    } catch (e) {
      print("Error editing schedule(service): $e");
      rethrow;
    }
  }
}
