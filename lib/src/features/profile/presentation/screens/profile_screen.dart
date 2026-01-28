import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:pak_tani/src/features/profile/presentation/widgets/contact_info_widget.dart';
import 'package:pak_tani/src/features/profile/presentation/widgets/edit_profile_widget.dart';
import 'package:pak_tani/src/features/profile/presentation/widgets/photo_profile_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = Get.width;
    final mediaQueryHeight = Get.height;
    final controller = Get.find<ProfileController>();

    return SafeArea(
      child: Container(
        height: mediaQueryHeight.h,
        width: mediaQueryWidth.w,
        padding: EdgeInsets.symmetric(vertical: 30.h),
        margin: EdgeInsets.only(bottom: 30.h),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 45.h,
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text("Profile", style: AppTheme.h3),
                  ),
                  Positioned(
                    right: 0,
                    child: MyIcon(
                      iconSize: 21,
                      padding: 11,
                      icon: LucideIcons.logOut,
                      iconColor: Colors.white,
                      backgroundColor: AppTheme.errorColor,
                      onPressed: controller.handleLogOut,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 30.h,
                children: [
                  PhotoProfileWidget(),
                  TabBar(
                    controller: controller.tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    dividerColor: Colors.transparent,
                    splashFactory: InkSparkle.splashFactory,
                    splashBorderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: [
                      Padding(
                        padding: EdgeInsets.all(10.r),
                        child: Text("Informasi Pribadi"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.r),
                        child: Text("Hubungi Kami"),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: TabBarView(
                        controller: controller.tabController,
                        children: [EditProfileWidget(), ContactInfoWidget()],
                      ),
                    ),
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
