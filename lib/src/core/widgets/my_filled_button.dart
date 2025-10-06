import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class MyFilledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final Color textColor;
  final Color backgroundColor;
  const MyFilledButton({
    super.key,
    required this.title,
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
      ),
      child: Text(title, style: TextStyle(color: textColor)),
    );
  }
}
