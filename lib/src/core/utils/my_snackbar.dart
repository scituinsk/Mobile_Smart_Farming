import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

/// A utility class for custom snackbars.
/// Contains static methods to display success and error notifications.
class MySnackbar {
  /// Shows a success snackbar with a green background and check icon.
  static void success({
    String title = "Success!",
    required String message,
  }) async {
    toastification.show(
      title: Text(title),
      description: Text(message),
      alignment: Alignment.bottomCenter,
      icon: const Icon(Icons.check_circle),
      margin: EdgeInsets.all(16.r),
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,
    );
  }

  static void error({String title = "Error!", required String message}) async {
    toastification.show(
      title: Text(title),
      description: Text(message),
      alignment: Alignment.bottomCenter,
      icon: const Icon(Icons.error_outline),
      margin: EdgeInsets.all(16.r),
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(milliseconds: 2500),
      dismissDirection: DismissDirection.horizontal,
      animationDuration: Duration(milliseconds: 500),
      showProgressBar: true,
    );
  }

  ///Shows a warning snackbar with an orange background and warning icon.
  static void warning({
    String title = "Warning!",
    required String message,
  }) async {
    toastification.show(
      title: Text(title),
      description: Text(message),
      alignment: Alignment.bottomCenter,
      icon: const Icon(Icons.warning_rounded),
      margin: EdgeInsets.all(16.r),
      type: ToastificationType.warning,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,
    );
  }

  static void info({
    String title = "Info!",
    required String message,
    bool instantInit = false,
  }) async {
    toastification.show(
      title: Text(title),
      description: Text(message),
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.all(16.r),
      type: ToastificationType.info,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,
    );
  }
}
