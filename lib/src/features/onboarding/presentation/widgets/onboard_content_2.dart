import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/onboarding/presentation/controllers/onboard_screen_controller.dart';

class OnboardContent2 extends StatelessWidget {
  const OnboardContent2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardScreenController>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            "assets/svgs/onboard_2.svg",
            height: 400.h,
            width: 400.w,
          ),
          Padding(
            padding: EdgeInsets.only(right: 46.0.w, left: 30.w),
            child: Column(
              spacing: 18.r,
              children: [
                Text("onboard_2_title".tr, style: AppTheme.onboardingTitle),
                Text(
                  "onboard_2_subtitle".tr,
                  style: AppTheme.h4.copyWith(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Align(
              alignment: Alignment.bottomRight,
              child: MyIcon(
                onPressed: controller.goNextContent,
                backgroundColor: AppTheme.primaryColor,
                iconColor: Colors.white,
                icon: LucideIcons.arrowRight,
                iconSize: 30,
                padding: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
