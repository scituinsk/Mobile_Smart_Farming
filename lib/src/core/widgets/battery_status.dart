/// A widget that displays the battery status with an icon and percentage text.
/// It shows a battery icon (full or low) based on the percentage and formats the display in a rounder container.

library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';

/// A stateless widget for displaying battery status.
/// Takes a percentage value and renders an icon and text accordingly.
class BatteryStatus extends StatelessWidget {
  final int percent;
  const BatteryStatus({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 4.r,
        children: [
          CustomIcon(
            type: percent > 50
                ? MyCustomIcon.batteryMax
                : MyCustomIcon.batteryLow,
            size: 20,
          ),

          Text("$percent%", style: AppTheme.textMedium),
        ],
      ),
    );
  }
}
