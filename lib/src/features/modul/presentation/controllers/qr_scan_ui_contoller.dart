import 'package:get/get.dart';
import 'package:pak_tani/src/core/utils/log_utils.dart';

class QrScanUiContoller extends GetxController {
  final RxBool isProcessingQR = false.obs;

  void processBarcode(String barcode) {
    if (isProcessingQR.value) {
      LogUtils.d("alredy processing, ignoring duplicate scan");
      return;
    }

    isProcessingQR.value = true;

    final callback = Get.arguments as Function(String)?;
    if (callback != null) {
      callback(barcode);
    } else {
      LogUtils.d("Warning: No callback provided for QR scan result");
    }

    LogUtils.d("barcode detected: $barcode");

    Get.back();
  }

  @override
  void onClose() {
    isProcessingQR.value = false;
    super.onClose();
  }
}
