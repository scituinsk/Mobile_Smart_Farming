import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class MyTextField extends StatelessWidget {
  final String title;
  final String hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double borderRadius;
  final double? fieldWidth;
  final TextStyle titleStyle;
  final Color fillColor;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.title,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius = 8,
    this.fieldWidth,
    this.titleStyle = AppTheme.h5,
    this.fillColor = const Color(0xFFEEEEEE),
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(title, style: titleStyle),
        SizedBox(
          width: fieldWidth,
          child: TextField(
            obscureText: obscureText,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,

              hintText: hint,
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              ),
              hintStyle: TextStyle(color: AppTheme.onDefaultColor),
            ),
          ),
        ),
      ],
    );
  }
}
