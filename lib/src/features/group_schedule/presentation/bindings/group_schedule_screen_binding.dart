import 'package:get/get.dart';
import 'package:pak_tani/src/features/group_schedule/presentation/controllers/group_schedule_ui_controller.dart';
import 'package:pak_tani/src/features/modul/application/services/relay_service.dart';

class GroupScheduleScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GroupScheduleUiController(Get.find<RelayService>()));
  }
}
