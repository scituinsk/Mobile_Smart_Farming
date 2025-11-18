import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_service.dart';
import 'package:pak_tani/src/features/modul/application/services/relay_service.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/relay_ui_controller.dart';

class RelayScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      RelayUiController(Get.find<RelayService>(), Get.find<ModulService>()),
    );
  }
}
