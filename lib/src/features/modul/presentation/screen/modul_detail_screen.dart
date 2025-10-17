import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/display_chip.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_detail_ui_controller.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_detail/modul_detail_content_widget.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_detail/modul_detail_data_item.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_detail/modul_detail_dropdown_menu.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_detail/modul_detail_feature_item.dart';

class ModulDetailScreen extends StatelessWidget {
  const ModulDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ModulDetailUiController());

    final mediaQueryWidth = Get.width;
    final mediaQueryHeight = Get.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: mediaQueryWidth,
          height: mediaQueryHeight,
          child: Stack(
            children: [
              SizedBox(
                height: 318,
                child: Stack(
                  children: [
                    Obx(() {
                      final modul = controller.modul.value;
                      late ImageProvider imageProvider;
                      if (modul != null) {
                        imageProvider = modul.image != null
                            ? NetworkImage(
                                "https://smartfarmingapi.teknohole.com${modul.image}",
                              )
                            : const AssetImage(
                                'assets/image/default_modul.jpg',
                              );
                      } else {
                        imageProvider = const AssetImage(
                          'assets/image/default_modul.jpg',
                        );
                      }

                      return Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    }),

                    // Image.asset(
                    //   'assets/image/default_modul.jpg',

                    // ),
                    Container(
                      height: 318,
                      width: mediaQueryWidth,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                          stops: [0.4, 1.0], // Atur posisi transisi gradient
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [MyBackButton(), ModulDetailDropdownMenu()],
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 30,
                      right: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          DisplayChip(
                            paddingHorizontal: 14,
                            child: Row(
                              spacing: 5,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIcon(type: MyCustomIcon.greenHouse),
                                Obx(
                                  () => Text(
                                    controller.modul.value != null
                                        ? controller.modul.value!.name
                                        : "Green House A",
                                    style: AppTheme.textMedium.copyWith(
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DisplayChip(
                            paddingHorizontal: 10,
                            child: Row(
                              spacing: 5,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIcon(type: MyCustomIcon.batteryMax),
                                Text("75%", style: AppTheme.textMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: mediaQueryHeight - 328,
                  width: mediaQueryWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 14,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ModulDetailContentWidget(
                          title: "Kode Modul",
                          content: Text(
                            "018bd6f8-7d8b-7132-842b-3247e",
                            style: AppTheme.textDefault,
                          ),
                        ),
                        ModulDetailContentWidget(
                          title: "Deskripsi Modul",
                          content: Text(
                            "Modul ini dibuat khusus untuk melakukan penyiraman di lokasi Green House A sebelah Timur, yang berisikan tanaman hidroponik melon, untuk jadwal penyiraman. ",
                            style: AppTheme.textDefault,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        ModulDetailContentWidget(
                          title: "Fitur Modul",
                          content: Row(
                            spacing: 20,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ModulDetailFeatureItem(
                                  title: "Solenoid",
                                  myCustomIcon: MyCustomIcon.solenoid,
                                  child: DisplayChip(
                                    paddingHorizontal: 16,
                                    backgroundColor: AppTheme.primaryColor,
                                    onPressed: () {
                                      Get.toNamed(RouteNamed.solenoidPage);
                                    },
                                    child: Row(
                                      spacing: 4,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Detail",
                                          style: AppTheme.text.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Icon(
                                          LucideIcons.arrowRight,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ModulDetailFeatureItem(
                                  title: "Water Pump",
                                  myCustomIcon: MyCustomIcon.waterPump,
                                  child: DisplayChip(
                                    paddingHorizontal: 16,
                                    backgroundColor: AppTheme.waterPumpColor,
                                    onPressed: () {},
                                    child: Text(
                                      "Aktif",
                                      style: AppTheme.text.copyWith(
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ModulDetailContentWidget(
                          title: "Data Modul",
                          content: Column(
                            spacing: 20,
                            children: [
                              ModulDetailDataItem(
                                myCustomIcon: MyCustomIcon.temprature,
                                title: "Suhu",
                                data: "26°C",
                              ),
                              ModulDetailDataItem(
                                myCustomIcon: MyCustomIcon.waterPH,
                                title: "Kelembapan",
                                data: "60 %",
                              ),
                              ModulDetailDataItem(
                                myCustomIcon: MyCustomIcon.waterLevel,
                                title: "Level Air",
                                data: "83 %",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
