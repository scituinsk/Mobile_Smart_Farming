import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/onboarding/presentation/controllers/onboard_screen_controller.dart';

class OnboardContent1 extends StatelessWidget {
  const OnboardContent1({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardScreenController>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        // spacing: 40.r,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16.0.w, left: 30.w),
            child: Column(
              spacing: 18.r,
              children: [
                Text(
                  "Irigasi Cerdas di Tangan Kamu",
                  style: AppTheme.onboardingTitle,
                ),
                Text(
                  "Kontrol penyiraman jadi simpel banget. Mulai langkah baru menuju pertanian modern dari genggamanmu.",
                  style: AppTheme.h4.copyWith(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            "assets/svgs/onboard_1.svg",
            width: 400.w,
            height: 400.h,
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
