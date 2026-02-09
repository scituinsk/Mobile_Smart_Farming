import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:pak_tani/src/core/utils/my_snackbar.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/qr_scan_ui_contoller.dart';

class QrScannScreen extends StatelessWidget {
  const QrScannScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<QrScanUiContoller>();

    return AiBarcodeScanner(
      // Kamera: guard empty
      onDetect: (capture) {
        final barcodes = capture.barcodes; // List<Barcode>
        if (barcodes.isEmpty) {
          MySnackbar.error(
            title: 'qr_not_found_title'.tr,
            message: 'qr_no_barcode_message'.tr,
          );
          return;
        }

        // Ambil nilai pertama yang valid
        final String? value = barcodes
            .map((b) => b.rawValue ?? b.displayValue)
            .firstWhere(
              (v) => v != null && v.trim().isNotEmpty,
              orElse: () => null,
            );

        if (value == null) {
          MySnackbar.error(
            title: 'qr_not_found_title'.tr,
            message: 'qr_no_value_message'.tr,
          );
          return;
        }

        ctrl.processBarcode(value);
      },
    );
  }
}
