import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

/// A stateless widget for a custom filled button.
/// Display button with filled background and text or widget child.
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return null; // Gunakan default disabled color
          }
          return backgroundColor; // Gunakan backgroundColor hanya jika onPressed tidak null
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return null;
          return textColor;
        }),
        elevation: WidgetStateProperty.all(
          0,
        ), // Hilangkan elevation untuk tampilan flat
        shadowColor: WidgetStateProperty.all(
          Colors.transparent,
        ), // Hilangkan shadow
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 20.w),
        ),
      ),
      child: child ?? Text(title ?? "", style: TextStyle(color: textColor)),
    );
  }
}
