import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/icon_widget.dart';

class InformationWidget extends StatelessWidget {
  final Color bgIcon;
  final MyCustomIcon customIcon;
  final String title;
  final int amount;
  const InformationWidget({
    super.key,
    required this.bgIcon,
    required this.customIcon,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          IconWidget(customIcon: customIcon, backgroundColor: bgIcon),
          Text(title, style: AppTheme.textMedium),
          Text(
            "$amount",
            style: AppTheme.h2Medium.copyWith(color: AppTheme.titleSecondary),
          ),
        ],
      ),
    );
  }
}
