import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/modul_feature_helper.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul_feature.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_detail_ui_controller.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_detail/modul_detail_data_item.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_detail/modul_detail_feature_item.dart';

class ModulDetailFeatureSection extends StatelessWidget {
  const ModulDetailFeatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ModulDetailUiController>();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
        child: Obx(() {
          final modul = controller.modul.value!;
          final relayGroups = controller.relayGroups;
          // print("UI rebuilding with modul: ${modul.name}");
          List<ModulFeature> modulDatas = [];

          if (modul.features != null) {
            modulDatas = modul.features!
                .where(
                  (feature) =>
                      feature.name == "temperature" ||
                      feature.name == "humidity" ||
                      feature.name == "water_level",
                )
                .toList();
          }

          return MasonryGridView.builder(
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: modulDatas.length + relayGroups.length + 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemBuilder: (context, index) {
              if (index == 0) {
                return InkWell(
                  borderRadius: BorderRadius.circular(10.r),
                  onTap: () {
                    Get.toNamed(RouteNames.relayPage);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.all(10.r),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 10.r,
                          children: [
                            Icon(Icons.settings, color: Colors.white, size: 28),
                            Expanded(
                              child: Text(
                                "Pengaturan Relay",
                                style: AppTheme.h4.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Atur group relay untuk mengatur penjadwalan",
                          style: AppTheme.textAction.copyWith(
                            color: AppTheme.surfaceColor,
                            fontSize: 11.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (index >= 1) {
                final relayIndex = index - 1;
                if (index <= relayGroups.length) {
                  return ModulDetailFeatureItem(
                    title: relayGroups[relayIndex].name,
                    myCustomIcon: MyCustomIcon.solenoid,
                    onPressed: () {
                      Get.toNamed(
                        RouteNames.groupSchedulePage,
                        arguments: relayGroups[relayIndex].id,
                      );
                    },
                  );
                }
              }

              final dataIndex = index - relayGroups.length - 1;
              final modulData = modulDatas[dataIndex];

              return ModulDetailDataItem(
                myCustomIcon: ModulFeatureHelper.getFeatureIcon(modulData.name),
                title: ModulFeatureHelper.getFeatureName(modulData.name),
                rawName: modulData.name,
                data: modulData.data,
                descriptions: modulData.descriptions ?? "",
                color: ModulFeatureHelper.getFeatureColor(modulData.name),
              );
            },
          );
        }),
      ),
    );
  }
}
