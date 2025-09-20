import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';

class IconWidget extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final Color backgroundColor;
  final double padding;
  final MyCustomIcon? customIcon;
  final VoidCallback? onPressed; // Tambahkan opsi onPressed

  const IconWidget({
    super.key,
    this.icon = Icons.notifications,
    this.iconColor = AppTheme.primaryColor,
    this.iconSize = 24,
    this.backgroundColor = Colors.white,
    this.padding = 8,
    this.customIcon,
    this.onPressed, // Tambahkan ke konstruktor
  });

  @override
  Widget build(BuildContext context) {
    Widget iconChild = customIcon != null
        ? SvgPicture.asset(
            iconAssets(customIcon!),
            height: iconSize,
            width: iconSize,
          )
        : Icon(icon, color: iconColor, size: iconSize);

    Widget content = Container(
      padding: EdgeInsets.all(padding),
      child: iconChild,
    );

    if (onPressed != null) {
      return Material(
        color: backgroundColor,
        shape: CircleBorder(),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onPressed,
          child: content,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      padding: EdgeInsets.all(padding),
      child: iconChild,
    );
  }
}
