import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/utils/modul_feature_helper.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
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
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Obx(() {
          final modul = controller.modul.value!;
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
            itemCount: modulDatas.length + 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ModulDetailFeatureItem(
                  title: "Relay",
                  icon: Icons.settings,
                  onPressed: () {
                    Get.toNamed(RouteNamed.relayPage);
                  },
                );
              }

              if (index == 1) {
                return ModulDetailFeatureItem(
                  title: "Green house A",
                  myCustomIcon: MyCustomIcon.solenoid,
                  onPressed: () {
                    Get.toNamed(
                      RouteNamed.groupSchedulePage,
                      arguments: "Green Gouse A",
                    );
                  },
                );
              }

              final dataIndex = index - 2;
              final modulData = modulDatas[dataIndex];

              // print("Building ${modulData.name} with data: ${modulData.data}");

              // final processedData = ModulFeatureHelper.getFeatureData(
              //   modulData.name,
              //   modulData.data,
              // );

              // print("Processed data for ${modulData.name}: $processedData");

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
