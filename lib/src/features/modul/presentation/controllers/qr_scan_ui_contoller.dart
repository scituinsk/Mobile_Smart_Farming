import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/add_modul_ui_controller.dart';

class QrScanUiContoller extends GetxController {
  final AddModulUiController addModulController;
  QrScanUiContoller(this.addModulController);

  final RxBool isProcessingQR = false.obs;

  void processBarcode(String barcode) {
    if (isProcessingQR.value) {
      print("alredy processing, ignoring duplicate scan");
      return;
    }

    isProcessingQR.value = true;
    addModulController.modulCodeController.text = barcode;

    print("barcode detected: ${addModulController.modulCodeController.value}");

    Get.back();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    isProcessingQR.value = false;
    super.onClose();
  }
}
