import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/icon_widget.dart';

class DashboardAppbar extends StatelessWidget {
  const DashboardAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(
                'assets/image/default_profile.jpg',
              ), // Update path as needed
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Selamat Pagi", style: AppTheme.textAction),
                Text(
                  "Kernessstra",
                  style: AppTheme.textMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconWidget(
          icon: Icons.notifications,
          iconColor: AppTheme.primaryColor,
          onPressed: () => Get.toNamed(RouteNamed.notificationPage),
        ),
      ],
    );
  }
}
