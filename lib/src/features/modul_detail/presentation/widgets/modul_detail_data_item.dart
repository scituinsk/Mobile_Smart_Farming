import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/icon_widget.dart';

class ModulDetailDataItem extends StatelessWidget {
  final MyCustomIcon myCustomIcon;
  final String title;
  final String data;
  const ModulDetailDataItem({
    super.key,
    required this.myCustomIcon,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),

      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 6,
            children: [
              IconWidget(customIcon: myCustomIcon),
              Text(title, style: AppTheme.h4),
            ],
          ),
          Text(data, style: AppTheme.h4.copyWith(color: AppTheme.primaryColor)),
        ],
      ),
    );
  }
}
