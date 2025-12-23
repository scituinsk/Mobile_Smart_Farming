import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomDialog {
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
                margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
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
