import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/icon_widget.dart';

class ModulDetailFeatureItem extends StatelessWidget {
  final String title;
  final MyCustomIcon myCustomIcon;
  final VoidCallback? onPressed;
  final Widget child;
  const ModulDetailFeatureItem({
    super.key,
    required this.title,
    required this.myCustomIcon,
    this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        spacing: 10,
        children: [
          IconWidget(customIcon: myCustomIcon),
          Text(title, style: AppTheme.textMedium),
          child,
        ],
      ),
    );
  }
}
