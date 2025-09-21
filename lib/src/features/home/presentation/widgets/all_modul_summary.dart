import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/features/home/presentation/widgets/modul_summary_widget.dart';

class AllModulSummary extends StatelessWidget {
  const AllModulSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: ModulSummaryWidget(
            bgIcon: AppTheme.surfaceColor,
            customIcon: MyCustomIcon.selenoid,
            title: "Selenoid Aktif",
            amount: 8,
          ),
        ),
        Expanded(
          child: ModulSummaryWidget(
            bgIcon: AppTheme.surfaceColor,
            customIcon: MyCustomIcon.waterPump,
            title: "Water Pump Aktif",
            amount: 3,
          ),
        ),
      ],
    );
  }
}
