import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';

class ModulInformation extends StatelessWidget {
  final MyCustomIcon customIcon;
  final String name;
  final String information;
  final bool isWaterPump;
  final Color iconColor;

  const ModulInformation({
    super.key,
    required this.customIcon,
    required this.name,
    required this.information,
    this.isWaterPump = false,
    this.iconColor = AppTheme.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyIcon(
          padding: 3,
          backgroundColor: AppTheme.surfaceColor,
          customIcon: customIcon,
          iconColor: iconColor,
        ),
        Text(name, style: AppTheme.text.copyWith(color: Colors.white)),
        isWaterPump
            ? SizedBox.shrink()
            : Text(
                information,
                style: AppTheme.textAction.copyWith(color: Colors.white),
              ),
      ],
    );
  }
}
