import 'package:get/get.dart';

class QrScanUiContoller extends GetxController {
  final RxBool isProcessingQR = false.obs;

  void processBarcode(String barcode) {
    if (isProcessingQR.value) {
      print("alredy processing, ignoring duplicate scan");
      return;
    }

    isProcessingQR.value = true;

    final callback = Get.arguments as Function(String)?;
    if (callback != null) {
      callback(barcode);
    } else {
      print("Warning: No callback provided for QR scan result");
    }

    print("barcode detected: $barcode");

    Get.back();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    isProcessingQR.value = false;
    super.onClose();
  }
}
