import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/config/app_config.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/modul_feature_helper.dart';
import 'package:pak_tani/src/core/widgets/battery_status.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_list/modul_information.dart';

class ModulItem extends StatelessWidget {
  final Modul modul;
  const ModulItem({super.key, required this.modul});

  @override
  Widget build(BuildContext context) {
    late ImageProvider imageProvider = modul.image != null
        ? NetworkImage((AppConfig.baseUrl + modul.image!))
        : const AssetImage('assets/image/default_modul.jpg');

    final batteryFeatureList = (modul.features ?? [])
        .where((feature) => feature.name == "battery")
        .toList();

    final int? batteryStatus = batteryFeatureList.isNotEmpty
        ? int.tryParse(batteryFeatureList.first.data)
        : null;

    return GestureDetector(
      onTap: () =>
          Get.toNamed(RouteNamed.detailModulPage, arguments: modul.serialId),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),

        height: 240,
        width: double.infinity,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              child: SizedBox(
                height: 155,
                width: double.infinity,
                child: Stack(
                  children: [
                    Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        constraints: BoxConstraints(maxWidth: 180),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/mdi-greenhouse.svg',
                              width: 20,
                              height: 20,
                            ),
                            Flexible(
                              child: Text(
                                modul.name,
                                style: AppTheme.textMedium.copyWith(
                                  color: AppTheme.primaryColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    batteryStatus != null
                        ? Positioned(
                            top: 8,
                            right: 8,
                            child: BatteryStatus(percent: batteryStatus),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: _buildFeaturesRow(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesRow() {
    final List<DeviceFeature> features = (modul.features ?? [])
        .where(
          (feature) =>
              feature.name == "temperature" ||
              feature.name == "humidity" ||
              feature.name == "water_level" ||
              feature.name == "schedule",
        )
        .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // physics: BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: features.map((feature) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ModulInformation(
              customIcon: ModulFeatureHelper.getFeatureIcon(feature.name),
              information: ModulFeatureHelper.getFeatureData(
                feature.name,
                feature.data,
              ),
              name: ModulFeatureHelper.getFeatureName(feature.name),
              isWaterPump: feature.name == "water_pump",
            ),
          );
        }).toList(),
      ),
    );
  }
}
