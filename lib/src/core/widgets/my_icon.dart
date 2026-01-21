import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';

/// A stateless widget for a custom Icon with filled background.
/// Display icon with a filled background, customable color, size, border radius, padding, icon or MyCustomIcon, and optionally clickable.
class MyIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final double iconWeight;
  final Color backgroundColor;
  final double padding;
  final MyCustomIcon? customIcon;
  final VoidCallback? onPressed;
  final double borderRadius;

  const MyIcon({
    super.key,
    this.icon = Icons.notifications,
    this.iconColor = AppTheme.primaryColor,
    this.iconSize = 24,
    this.iconWeight = 8,
    this.backgroundColor = Colors.white,
    this.padding = 8,
    this.customIcon,
    this.onPressed,
    this.borderRadius = 100,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconChild = customIcon != null
        ? CustomIcon(type: customIcon!, size: iconSize, color: iconColor)
        : Icon(icon, color: iconColor, size: iconSize.r, weight: iconWeight.r);

    Widget content = Container(
      padding: EdgeInsets.all(padding.r),
      child: iconChild,
    );

    if (onPressed != null) {
      return Material(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius.r),
          onTap: onPressed,
          child: content,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      padding: EdgeInsets.all(padding.r),
      child: iconChild,
    );
  }
}
