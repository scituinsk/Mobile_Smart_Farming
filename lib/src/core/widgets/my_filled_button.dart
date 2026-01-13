import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class MyFilledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? title;
  final Color textColor;
  final Color backgroundColor;
  final Widget? child;
  const MyFilledButton({
    super.key,
    this.title,
    this.child,
    required this.onPressed,
    this.textColor = Colors.white,
    this.backgroundColor = AppTheme.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        ),
      ),
      child: child ?? Text(title ?? "", style: TextStyle(color: textColor)),
    );
  }
}
