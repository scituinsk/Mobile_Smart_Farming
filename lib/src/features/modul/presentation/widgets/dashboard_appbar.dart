import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/controllers/main_navigation_controller.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';

class DashboardAppbar extends StatelessWidget {
  const DashboardAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final mainCotroller = Get.find<MainNavigationController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 12.r,
          children: [
            CustomIcon(type: MyCustomIcon.logoPrimary, size: 50),
            Text("app_name".tr, style: AppTheme.h3),
          ],
        ),
        Row(
          spacing: 12.r,
          children: [
            Obx(
              () => Badge(
                label: Text(
                  mainCotroller.unreadNotificationCount.value.toString(),
                ),
                isLabelVisible: mainCotroller.unreadNotificationCount.value > 0,
                child: MyIcon(
                  icon: Icons.notifications,
                  iconColor: AppTheme.primaryColor,
                  onPressed: () => Get.toNamed(RouteNames.notificationPage),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
