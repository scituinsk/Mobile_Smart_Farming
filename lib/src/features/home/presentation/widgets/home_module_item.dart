import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/battery_status.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/features/home/presentation/widgets/modul_information.dart';

class HomeModuleItem extends StatelessWidget {
  final bool waterpumpStatus;
  final String name;
  const HomeModuleItem({
    super.key,
    this.waterpumpStatus = true,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(RouteNamed.detailModulPage),
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
                    Image.asset(
                      'assets/image/default_modul.jpg',
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
                            Text(
                              name,
                              style: AppTheme.textMedium.copyWith(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: BatteryStatus(percent: 80),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ModulInformation(
                    customIcon: MyCustomIcon.temprature,
                    name: "Suhu",
                    information: "+26°C",
                  ),
                  ModulInformation(
                    customIcon: MyCustomIcon.waterPH,
                    name: "Kelembapan",
                    information: "60.2%",
                  ),
                  ModulInformation(
                    customIcon: MyCustomIcon.waterLevel,
                    name: "Level Air",
                    information: "83%",
                  ),
                  ModulInformation(
                    customIcon: MyCustomIcon.waterPump,
                    name: "Water Pump",
                    information: "+26°C",
                    isWaterPump: true,
                    waterpumpStatus: waterpumpStatus,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
