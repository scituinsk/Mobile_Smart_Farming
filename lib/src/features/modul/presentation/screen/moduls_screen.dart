import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/dashboard_appbar.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_list/modul_list.dart';

class ModulsScreen extends StatelessWidget {
  const ModulsScreen({super.key});

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
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 22.h),
            child: Column(
              spacing: 26.r,
              mainAxisSize: MainAxisSize.min,
              children: [DashboardAppbar(), ModulList()],
            ),
          ),

          Positioned(
            bottom: 90.h,
            right: 20.w,
            child: FloatingActionButton(
              onPressed: () {
                Get.toNamed(RouteNames.addModulPage);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Icon(LucideIcons.plus),
            ),
          ),
        ],
      ),
    );
  }
}
