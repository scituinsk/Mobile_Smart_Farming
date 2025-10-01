import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/icon_widget.dart';
import 'package:pak_tani/src/core/widgets/waterpump_tag.dart';

class ModulInformation extends StatelessWidget {
  final MyCustomIcon customIcon;
  final String name;
  final String information;
  final bool isWaterPump;
  final bool waterpumpStatus;

  const ModulInformation({
    super.key,
    required this.customIcon,
    required this.name,
    required this.information,
    this.isWaterPump = false,
    this.waterpumpStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconWidget(
          padding: 3,
          backgroundColor: AppTheme.surfaceColor,
          customIcon: customIcon,
        ),
        Text(name, style: AppTheme.textMedium.copyWith(color: Colors.white)),
        isWaterPump
            ? WaterpumpTag(isActive: waterpumpStatus)
            : Text(
                information,
                style: AppTheme.text.copyWith(color: Colors.white),
              ),
      ],
    );
  }
}
