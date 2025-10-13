import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/icon_widget.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 10,
      children: [
        Expanded(
          child: MyTextField(
            title: "Kode Modul",
            hint: "Ex: 018bd6f8-7d8b-7132-842b-3247e",
            fillColor: Colors.white,
          ),
        ),
        IconWidget(
          icon: LucideIcons.scanLine,
          iconColor: AppTheme.primaryColor,
          backgroundColor: AppTheme.waterPumpColor,
          iconSize: 30,
          borderRadius: 10,
          padding: 12,
          onPressed: () {},
        ),
      ],
    );
  }
}
