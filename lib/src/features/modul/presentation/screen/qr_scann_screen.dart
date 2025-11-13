import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/qr_scan_ui_contoller.dart';

class QrScannScreen extends StatelessWidget {
  const QrScannScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QrScanUiContoller>();

    return AiBarcodeScanner(
      onDetect: (BarcodeCapture capture) {
        final code = capture.barcodes.first.rawValue;

        if (code == null || code.isEmpty) {
          print("❌ Invalid barcode");
          return;
        }
        controller.processBarcode(code);
      },
    );
  }
}
