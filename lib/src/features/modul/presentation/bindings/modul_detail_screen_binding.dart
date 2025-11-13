import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_controller.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_detail_ui_controller.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/relay_controller.dart';

class ModulDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ModulDetailUiController(
        Get.find<ModulController>(),
        Get.find<RelayController>(),
      ),
    );
  }
}
