import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/add_modul_ui_controller.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_controller.dart';

class AddModulScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddModulUiController(Get.find<ModulController>()));
  }
}
