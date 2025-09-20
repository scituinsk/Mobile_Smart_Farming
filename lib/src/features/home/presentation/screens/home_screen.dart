import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/features/home/presentation/widgets/home_module_list.dart';
import 'package:pak_tani/src/features/home/presentation/widgets/information_widget.dart';
import 'package:pak_tani/src/core/widgets/dashboard_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = Get.width;
    final mediaQueryHeight = Get.height;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        width: mediaQueryWidth,
        height: mediaQueryHeight,
        child: Column(
          spacing: 20,
          children: [
            DashboardAppbar(),
            Text(
              "Yuk Atur Jadwal Penyiraman Untuk Hari Ini!",
              style: AppTheme.h2SemiBold,
            ),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: InformationWidget(
                    bgIcon: AppTheme.surfaceColor,
                    customIcon: MyCustomIcon.selenoid,
                    title: "Selenoid Aktif",
                    amount: 8,
                  ),
                ),
                Expanded(
                  child: InformationWidget(
                    bgIcon: AppTheme.surfaceColor,
                    customIcon: MyCustomIcon.waterPump,
                    title: "Water Pump Aktif",
                    amount: 3,
                  ),
                ),
              ],
            ),
            HomeModuleList(),
          ],
        ),
      ),
    );
  }
}
