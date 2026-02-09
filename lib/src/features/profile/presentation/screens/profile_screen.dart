import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/profile/presentation/controllers/profile_controller.dart';
import 'package:pak_tani/src/features/profile/presentation/widgets/contact_info_widget.dart';
import 'package:pak_tani/src/features/profile/presentation/widgets/edit_profile_widget.dart';
import 'package:pak_tani/src/features/profile/presentation/widgets/logout_dialog.dart';
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
                  Positioned(
                    left: 0,
                    child: MyIcon(
                      iconSize: 21,
                      padding: 11,
                      icon: LucideIcons.languages,
                      iconColor: AppTheme.primaryColor,
                      backgroundColor: AppTheme.primaryColor.withValues(
                        alpha: 0.1,
                      ),
                      onPressed: () => _showLanguageBottomSheet(context),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text("profile_title".tr, style: AppTheme.h3),
                  ),
                  Positioned(
                    right: 0,
                    child: MyIcon(
                      iconSize: 21,
                      padding: 11,
                      icon: LucideIcons.logOut,
                      iconColor: Colors.white,
                      backgroundColor: AppTheme.errorColor,
                      onPressed: () => LogoutDialog.show(context),
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
                  const PhotoProfileWidget(),

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
                        child: Text("profile_tab_personal".tr),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.r),
                        child: Text("profile_tab_contact".tr),
                      ),
                    ],
                  ),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: TabBarView(
                        controller: controller.tabController,
                        children: const [
                          EditProfileWidget(),
                          ContactInfoWidget(),
                        ],
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

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      elevation: 0,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.of(context).padding.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "change_language".tr,
                style: AppTheme.h3.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),

              _buildLanguageItem(
                label: "Bahasa Indonesia",
                flag: "🇮🇩",
                code: 'id',
                countryCode: 'ID',
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Divider(height: 1, thickness: 0.5),
              ),
              _buildLanguageItem(
                label: "English",
                flag: "🇺🇸",
                code: 'en',
                countryCode: 'US',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageItem({
    required String label,
    required String flag,
    required String code,
    required String countryCode,
  }) {
    final bool isSelected = Get.locale?.languageCode == code;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        if (!isSelected) {
          Get.updateLocale(Locale(code, countryCode));
        }
        Get.back();
      },
      leading: Text(flag, style: TextStyle(fontSize: 24.sp)),
      title: Text(
        label,
        style: isSelected
            ? AppTheme.text.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              )
            : AppTheme.text,
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.primaryColor,
              size: 24,
            )
          : null,
      tileColor: isSelected
          ? AppTheme.primaryColor.withValues(alpha: 0.05)
          : Colors.transparent,
    );
  }
}
