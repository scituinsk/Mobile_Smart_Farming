import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/add_modul_ui_controller.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/qr_scan_ui_contoller.dart';

class QrScanScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(QrScanUiContoller(Get.find<AddModulUiController>()));
  }
}
