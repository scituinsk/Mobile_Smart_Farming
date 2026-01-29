/// A utility class for displaying and hiding a loading dialog.
/// Porvides static methods to show a non-dismissible loading indicator and hide it using GetX.

library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

/// A utility class for managing loading dialogs.
/// Contains static methods to display a loading spinner and dismiss it.
class LoadingDialog {
  /// Shows a loading dialog widh a circular progress indicator.
  /// The dialog is non-dismissible and prevent user interaction until hidden.
  /// Does nothing if a dialog is alredy open.
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
      routeSettings: RouteSettings(name: "loading"),
    );
  }

  /// Hides the currently open loading dialog.
  /// Does nothing if no dialog is open to avoid errors.
  static void hide() {
    // Check if a dialog is open before trying to close it to avoid errors.
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
