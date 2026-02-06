/// A utility class for displaying custom dialogs in the app.
/// Provides a static method to show a dialog with customizable title, content, and dimensions using GetX.

library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// A utility class for custom dialog widgets.
/// Contains static methods to display dialogs with flexible layouts.
class CustomDialog {
  /// Shows a custom dialog with the give title and child content.
  ///
  /// - [context]: the build context.
  /// - [title]: The widget to display as the dialog title.
  /// - [child]: the main content widget of the dialog.
  /// - [widthTitle]: Optional width for the title container.
  /// - [widthChild]: Optional width for the child container.
  /// - [height]: Optional height for the dialog.
  /// - [dialogMargin]: Horizontal margin for the dialog, use this to manage size of the dialog. the larger the margin, the smaller the dialog is
  static Future<void> show({
    required BuildContext context,
    required Widget title,
    required Widget child,
    double? widthTitle,
    double? widthChild,
    double? height,
    double dialogMargin = 5,
  }) async {
    await Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(
          vertical: 5.h,
          horizontal: dialogMargin.w,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Container(
          height: height?.h,
          constraints: BoxConstraints(maxWidth: 500.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: widthTitle?.w ?? double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
                child: title,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
                width: widthChild?.w,
                child: child,
              ),
            ],
          ),
        ),
      ),

      barrierDismissible: true,
    );
  }
}
