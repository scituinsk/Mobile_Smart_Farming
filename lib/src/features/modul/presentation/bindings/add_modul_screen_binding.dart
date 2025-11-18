import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_service.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/add_modul_ui_controller.dart';

class AddModulScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddModulUiController(Get.find<ModulService>()));
  }
}
