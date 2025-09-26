import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/widgets/dashboard_appbar.dart';
import 'package:pak_tani/src/features/module/presentation/widgets/filter_modul.dart';
import 'package:pak_tani/src/features/module/presentation/widgets/modul_list.dart';

class ModuleScreen extends StatelessWidget {
  const ModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = Get.width;
    final mediaQueryHeight = Get.height;

    return SafeArea(
      child: Stack(
        children: [
          Container(
            width: mediaQueryWidth,
            height: mediaQueryHeight,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 22),
            child: Column(
              spacing: 26,
              mainAxisSize: MainAxisSize.min,
              children: [DashboardAppbar(), FilterModul(), ModulList()],
            ),
          ),

          Positioned(
            bottom: 90,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Get.toNamed(RouteNamed.addModulPage);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(LucideIcons.plus),
            ),
          ),
        ],
      ),
    );
  }
}
