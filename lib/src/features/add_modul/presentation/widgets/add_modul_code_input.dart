import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/icon_widget.dart';

class AddModulCodeInput extends StatelessWidget {
  final String title;
  final String hintText;
  const AddModulCodeInput({
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
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: TextField(
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
            ),
            IconWidget(
              icon: LucideIcons.scanLine,
              iconColor: AppTheme.primaryColor,
              backgroundColor: AppTheme.waterPumpColor,
              borderRadius: 10,
              padding: 12,
            ),
          ],
        ),
      ],
    );
  }
}
