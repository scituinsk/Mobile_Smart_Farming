import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
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
          Get.snackbar('Tidak ditemukan', 'Tidak ada QR/Barcode terdeteksi');
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
          Get.snackbar('Tidak ditemukan', 'Kode tidak memiliki nilai teks');
          return;
        }

        ctrl.processBarcode(value);
      },

      // Tombol galeri: guard empty
      // overlayBuilder: (context, controller) {
      //   return Align(
      //     alignment: Alignment.bottomCenter,
      //     child: Padding(
      //       padding: const EdgeInsets.only(bottom: 24),
      //       child: GalleryButton(
      //         // Callback bawaan plugin ketika selesai analisa gambar
      //         onScan: (barcodes) {
      //           if (barcodes == null || barcodes.isEmpty) {
      //             Get.snackbar(
      //               'Tidak ditemukan',
      //               'Gambar tidak mengandung QR/Barcode',
      //             );
      //             return;
      //           }

      //           final String? value = barcodes
      //               .map((b) => b.rawValue ?? b.displayValue)
      //               .firstWhere(
      //                 (v) => v != null && v.trim().isNotEmpty,
      //                 orElse: () => null,
      //               );

      //           if (value == null) {
      //             Get.snackbar(
      //               'Tidak ditemukan',
      //               'Tidak ada nilai teks pada barcode',
      //             );
      //             return;
      //           }

      //           ctrl.processBarcode(value);
      //         },
      //       ),
      //     ),
      //   );
      // },
    );
  }
}
