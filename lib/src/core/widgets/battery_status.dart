import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';

class BatteryStatus extends StatelessWidget {
  final int percent;
  const BatteryStatus({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 4,
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
