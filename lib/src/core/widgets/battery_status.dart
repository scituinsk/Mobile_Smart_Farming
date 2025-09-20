import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

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
          SvgPicture.asset(
            percent > 50
                ? 'assets/icons/fluent-battery-924-regular.svg'
                : 'assets/icons/fluent-battery-432-regular.svg',
          ),
          Text("$percent %", style: AppTheme.textMedium),
        ],
      ),
    );
  }
}
