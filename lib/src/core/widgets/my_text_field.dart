import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class MyTextField extends StatelessWidget {
  final String title;
  final String hint;
  final Widget? prefixIcon;
  final double borderRadius;
  final double? fieldWidth;
  const MyTextField({
    super.key,
    required this.title,
    required this.hint,
    this.prefixIcon,
    this.borderRadius = 8,
    this.fieldWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(title, style: AppTheme.h5),
        SizedBox(
          width: fieldWidth,
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              hintText: hint,
              filled: true,
              fillColor: Colors.grey.shade200,
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
