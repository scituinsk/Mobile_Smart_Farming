import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_dialog.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/features/profile/presentation/controllers/profile_controller.dart';

class LogoutDialog {
  static void show(BuildContext context) async {
    CustomDialog.show(
      context: context,
      dialogMargin: 35,
      widthTitle: double.infinity,
      title: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Column(
          spacing: 8.r,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(LucideIcons.logOut, color: AppTheme.errorColor, size: 38.r),
            Text("Keluar dari akun ini?", style: AppTheme.h4),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 38.w),
        child: Column(
          spacing: 20.r,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Kamu akan keluar dari akun ini dan harus login ulang untuk mengkakses aplikasi lagi.\nYakin keluar akun?",
              textAlign: TextAlign.center,
              style: AppTheme.textDefault,
            ),
            Row(
              spacing: 15.r,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyFilledButton(
                  title: "Batal",
                  onPressed: () {
                    Get.back();
                  },
                  backgroundColor: AppTheme.surfaceColor,
                  textColor: AppTheme.surfaceDarker,
                ),
                MyFilledButton(
                  title: "Keluar",
                  onPressed: () async {
                    Get.back();
                    final controller = Get.find<ProfileController>();
                    await controller.handleLogOut();
                  },
                  backgroundColor: AppTheme.errorColor,
                  textColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
