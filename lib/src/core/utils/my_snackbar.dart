import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// A utility class for custom snackbars.
/// Contains static methods to display success and error notifications.
class MySnackbar {
  /// Shows a success snackbar with a green background and check icon.
  static void success({
    String title = "Success!",
    required String message,
  }) async {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF2E7D32),
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      margin: EdgeInsets.all(16.r),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,
    );
  }

  ///Shows an error snackbar with a red background and error icon.
  static void error({String title = "Error!", required String message}) async {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFD32F2F),
      colorText: Colors.white,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      margin: EdgeInsets.all(16.r),
      borderRadius: 8,
      duration: const Duration(seconds: 4),
      dismissDirection: DismissDirection.horizontal,
    );
  }
}
