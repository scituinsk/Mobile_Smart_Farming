import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_display_chip.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';

class ModulDetailDataItem extends StatelessWidget {
  final MyCustomIcon myCustomIcon;
  final String title;
  final String descriptions;
  final String data;
  final Color color;

  const ModulDetailDataItem({
    super.key,
    required this.myCustomIcon,
    required this.title,
    required this.data,
    required this.descriptions,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              MyIcon(
                customIcon: myCustomIcon,
                iconColor: color,
                backgroundColor: color.withValues(alpha: 0.2),
              ),
              Text(title, style: AppTheme.h4),
            ],
          ),
          Text(descriptions, style: AppTheme.textAction),
          Align(
            alignment: Alignment.centerRight,
            child: MyDisplayChip(
              backgroundColor: color.withValues(alpha: 0.2),
              paddingHorizontal: 12,
              child: Text(data, style: AppTheme.h3.copyWith(color: color)),
            ),
          ),
        ],
      ),
    );
  }
}
