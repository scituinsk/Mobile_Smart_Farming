import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
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
            Obx(() {
              final user = authController.currentUser.value;
              if (user == null) {
                print("nggak ada gambar");
                return const CircleAvatar(
                  radius: 24,
                  child: Icon(Icons.person),
                );
              }
              print(user.image);
              final ImageProvider imageProvider = user.image != null
                  ? NetworkImage(
                      "https://smartfarmingapi.teknohole.com${authController.currentUser.value!.image!}",
                    )
                  : const AssetImage('assets/image/default_profile.jpg');

              return CircleAvatar(radius: 24, backgroundImage: imageProvider);
            }),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Selamat Pagi", style: AppTheme.textAction),
                Text(
                  authController.currentUser.value!.username,
                  style: AppTheme.textMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: authController.logout,
          icon: Icon(Icons.logout),
        ), //testing doang
        IconWidget(
          icon: Icons.notifications,
          iconColor: AppTheme.primaryColor,
          onPressed: () => Get.toNamed(RouteNamed.notificationPage),
        ),
      ],
    );
  }
}
