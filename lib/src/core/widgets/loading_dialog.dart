import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class LoadingDialog {
  static void show() {
    if (Get.isDialogOpen ?? false) {
      return;
    }

    Get.dialog(
      PopScope(
        canPop: false,
        child: const Center(
          child: CircularProgressIndicator(
            // Optional: style the indicator
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            strokeWidth: 6,
          ),
        ),
      ),
      barrierColor: Colors.black.withValues(alpha: 0.3),
      barrierDismissible: false,
    );
  }

  static void hide() {
    // Check if a dialog is open before trying to close it to avoid errors.
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
