import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_dialog.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/core/widgets/my_snackbar.dart';

class SolenoidEmergencyDialog {
  static show(BuildContext context) {
    CustomDialog.show(
      context: context,
      dialogMargin: 35,
      widthTitle: double.infinity,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.warning_rounded, color: AppTheme.primaryColor, size: 38),
            Text("Peringatan!", style: AppTheme.h4),
            Text('Nonaktifkan semua solenoid?', style: AppTheme.textAction),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Tindakan ini akan menghentikan semua jadwal dan operasi irigasi.",
              textAlign: TextAlign.center,
              style: AppTheme.textDefault,
            ),
            Row(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyFilledButton(
                  title: "Batal",
                  onPressed: () {
                    Get.back();
                  },
                  backgroundColor: AppTheme.surfaceColor,
                  textColor: AppTheme.primaryColor,
                ),
                MyFilledButton(
                  title: "Konfirmasi",
                  onPressed: () {
                    MySnackbar.error(
                      title: "Coming soon...",
                      message: "fitur belum ada, sabar bang :)",
                    );
                  },
                  backgroundColor: AppTheme.errorColor,
                  textColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
