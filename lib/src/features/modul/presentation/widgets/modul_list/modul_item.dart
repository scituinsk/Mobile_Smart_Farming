import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/display_chip.dart';
import 'package:pak_tani/src/core/widgets/icon_widget.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';

class ModulItem extends StatelessWidget {
  final Modul modul;
  const ModulItem({super.key, required this.modul});

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
                      modul.name,
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
                onPressed: () => Get.toNamed(
                  RouteNamed.detailModulPage,
                  arguments: modul.serialId,
                ),
              ),
            ],
          ),
          Column(
            spacing: 9,
            children: [
              if (modul.features != null) _buildFeaturesRow(),

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
                          true ? "Aktif" : "Non-aktif",
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

  Widget _buildFeaturesRow() {
    return Row(
      spacing: 9,
      children: [
        ...modul.features!.map((feature) {
          return (feature.name != "schedule")
              ? DisplayChip(
                  paddingHorizontal: 9,
                  paddingVertical: 9,
                  backgroundColor: AppTheme.surfaceColor,
                  child: Row(
                    spacing: 4,
                    children: [
                      CustomIcon(type: _getFeatureIcon(feature.name), size: 24),
                      Text(feature.data, style: AppTheme.textSmallMedium),
                    ],
                  ),
                )
              : SizedBox.shrink();
        }),
      ],
    );
  }

  MyCustomIcon _getFeatureIcon(String? featureName) {
    switch (featureName?.toLowerCase()) {
      case 'temprature':
        return MyCustomIcon.temprature;
      case "water_level":
        return MyCustomIcon.waterLevel;
      case 'humidity':
        return MyCustomIcon.waterPH;
      default:
        return MyCustomIcon.solenoid;
    }
  }
}
