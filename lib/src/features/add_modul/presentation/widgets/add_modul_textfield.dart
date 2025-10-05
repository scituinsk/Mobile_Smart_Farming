import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class AddModulTextfield extends StatelessWidget {
  final String title;
  final String hintText;
  const AddModulTextfield({
    super.key,
    required this.title,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.h4),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(color: AppTheme.onDefaultColor),
          ),
        ),
      ],
    );
  }
}
