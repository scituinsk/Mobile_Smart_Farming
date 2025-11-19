import 'package:get/get.dart';
import 'package:pak_tani/src/features/group_schedule/domain/entities/schedule.dart';
import 'package:pak_tani/src/features/group_schedule/domain/repositories/schedule_repository.dart';

class ScheduleService extends GetxService {
  final ScheduleRepository _repository;
  ScheduleService(this._repository);

  final RxBool isLoading = false.obs;

  final RxList<Schedule> schedules = <Schedule>[].obs;
  final Rx<Schedule?> selectedSchedules = Rx<Schedule?>(null);

  Future<void> loadSchedules(int groupId) async {
    isLoading.value = true;
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
      print("error loading schedules(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
