import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_service.dart';
import 'package:pak_tani/src/features/relays/application/services/relay_service.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_detail_ui_controller.dart';

class ModulDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ModulDetailUiController(
        Get.find<ModulService>(),
        Get.find<RelayService>(),
      ),
    );
  }
}
