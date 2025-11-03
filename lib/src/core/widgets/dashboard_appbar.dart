import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/icon_widget.dart';
import 'package:pak_tani/src/features/auth/presentation/controller/auth_controller.dart';

class DashboardAppbar extends StatelessWidget {
  const DashboardAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            CustomIcon(type: MyCustomIcon.logoPrimary, size: 50),
            Text("PakTani", style: AppTheme.h3),
          ],
        ),
        IconButton(
          onPressed: authController.logout,
          icon: Icon(Icons.logout),
        ), //testing doang
        Row(
          spacing: 12,
          children: [
            IconWidget(
              icon: LucideIcons.search,
              iconColor: AppTheme.primaryColor,
              onPressed: () {},
            ),
            IconWidget(
              icon: Icons.notifications,
              iconColor: AppTheme.primaryColor,
              onPressed: () => Get.toNamed(RouteNamed.notificationPage),
            ),
          ],
        ),
      ],
    );
  }
}
