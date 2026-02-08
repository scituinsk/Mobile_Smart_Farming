import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class SolenoidStatusChip extends StatelessWidget {
  final bool status;
  const SolenoidStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return status
        ? Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.lightGreenAccent, width: 1.w),
            ),
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 7.w),
            child: Text(
              "solenoid_status_active".tr,
              style: AppTheme.textSmall.copyWith(color: Colors.green),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.red.shade200, width: 1.w),
            ),
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 7.w),
            child: Text(
              "solenoid_status_inactive".tr,
              style: AppTheme.textSmall.copyWith(color: Colors.red),
            ),
          );
  }
}
