import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/display_chip.dart';
import 'package:pak_tani/src/core/widgets/icon_widget.dart';

class ModulItem extends StatelessWidget {
  final String title;
  final String temprature;
  final String waterPH;
  final String waterLevel;
  final bool waterPumpStatus;
  const ModulItem({
    super.key,
    required this.title,
    required this.temprature,
    required this.waterPH,
    required this.waterLevel,
    required this.waterPumpStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        spacing: 23,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DisplayChip(
                paddingHorizontal: 11,
                paddingVertical: 4,
                backgroundColor: AppTheme.surfaceColor,
                child: Row(
                  children: [
                    CustomIcon(type: MyCustomIcon.greenHouse),
                    Text(
                      title,
                      style: AppTheme.textSmallMedium.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              IconWidget(
                icon: Icons.arrow_outward_rounded,
                backgroundColor: AppTheme.secondaryColor,
                iconColor: Colors.white,
                onPressed: () => Get.toNamed(RouteNamed.detailModulPage),
              ),
            ],
          ),
          Column(
            spacing: 9,
            children: [
              Row(
                spacing: 9,
                children: [
                  DisplayChip(
                    paddingHorizontal: 9,
                    paddingVertical: 9,
                    backgroundColor: AppTheme.surfaceColor,
                    child: Row(
                      spacing: 4,
                      children: [
                        CustomIcon(type: MyCustomIcon.temprature, size: 24),
                        Text(temprature, style: AppTheme.textSmallMedium),
                      ],
                    ),
                  ),
                  DisplayChip(
                    paddingHorizontal: 9,
                    paddingVertical: 9,
                    backgroundColor: AppTheme.surfaceColor,
                    child: Row(
                      spacing: 4,
                      children: [
                        CustomIcon(type: MyCustomIcon.waterPH, size: 24),
                        Text(waterPH, style: AppTheme.textSmallMedium),
                      ],
                    ),
                  ),
                  DisplayChip(
                    paddingHorizontal: 9,
                    paddingVertical: 9,
                    backgroundColor: AppTheme.surfaceColor,
                    child: Row(
                      spacing: 4,
                      children: [
                        CustomIcon(type: MyCustomIcon.waterLevel, size: 24),
                        Text(waterLevel, style: AppTheme.textSmallMedium),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                spacing: 9,
                children: [
                  DisplayChip(
                    paddingHorizontal: 9,
                    paddingVertical: 9,
                    backgroundColor: AppTheme.surfaceColor,
                    child: Row(
                      spacing: 4,
                      children: [
                        CustomIcon(type: MyCustomIcon.waterPump, size: 24),
                        Text(
                          waterPumpStatus ? "Aktif" : "Non-aktif",
                          style: AppTheme.textSmallMedium,
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => Get.toNamed(RouteNamed.solenoidPage),
                    label: Text("Detail Solenoid"),
                    icon: Icon(Icons.arrow_forward_rounded),
                    iconAlignment: IconAlignment.end,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
