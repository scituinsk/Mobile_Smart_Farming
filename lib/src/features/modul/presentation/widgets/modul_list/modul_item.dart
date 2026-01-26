import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/config/app_config.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/modul_feature_helper.dart';
import 'package:pak_tani/src/core/widgets/battery_status.dart';
import 'package:pak_tani/src/features/modul/domain/entities/feature_data.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul_feature.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_list/modul_information.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_list/modul_locked_dialog.dart';

class ModulItem extends StatelessWidget {
  final Modul modul;
  const ModulItem({super.key, required this.modul});

  @override
  Widget build(BuildContext context) {
    late ImageProvider imageProvider = modul.image != null
        ? NetworkImage((AppConfig.baseUrl + modul.image!))
        : const AssetImage('assets/image/default_modul.jpg');

    final batteryFeature = (modul.features ?? [])
        .where((feature) => feature.name == "battery")
        .firstOrNull;

    final int? batteryStatus = ModulFeatureHelper.getBatteryValue(
      batteryFeature,
    );

    return GestureDetector(
      onTap: modul.isLocked!
          ? () => ModulLockedDialog.show(context, modul.serialId)
          : () => Get.toNamed(
              RouteNames.detailModulPage,
              arguments: {"serial_id": modul.serialId},
            ),
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(20.r),
            ),

            // height: 240,
            width: double.infinity,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  child: SizedBox(
                    height: 155.h,
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
                          top: 8.h,
                          left: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            constraints: BoxConstraints(maxWidth: 180.w),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/mdi-greenhouse.svg',
                                  width: 20.w,
                                  height: 20.h,
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
                                top: 8.h,
                                right: 8.w,
                                child: BatteryStatus(percent: batteryStatus),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 12.h,
                  ),
                  child: _buildFeaturesRow(),
                ),
              ],
            ),
          ),
          if (modul.isLocked!)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(
                    alpha: 0.5,
                  ), // Overlay hitam transparan
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock, // Icon locked
                        color: Colors.white,
                        size: 40.sp,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Locked', // Tulisan
                        style: AppTheme.textMedium.copyWith(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturesRow() {
    final List<ModulFeature> features = (modul.features ?? [])
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
            padding: EdgeInsets.only(right: 10.w),
            child: ModulInformation(
              customIcon: ModulFeatureHelper.getFeatureIcon(feature.name),
              iconColor: ModulFeatureHelper.getFeatureColor(feature.name),
              name: feature.name,
              isWaterPump: feature.name == "water_pump",
              featureData: feature.data ?? <FeatureData>[],
            ),
          );
        }).toList(),
      ),
    );
  }
}
