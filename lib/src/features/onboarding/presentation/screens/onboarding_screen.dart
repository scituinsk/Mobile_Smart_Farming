import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/onboarding/presentation/controllers/onboard_screen_controller.dart';
import 'package:pak_tani/src/features/onboarding/presentation/widgets/onboard_content_1.dart';
import 'package:pak_tani/src/features/onboarding/presentation/widgets/onboard_content_2.dart';
import 'package:pak_tani/src/features/onboarding/presentation/widgets/onboard_content_3.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardScreenController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Padding(
                padding: EdgeInsets.all(30.r),
                child: LinearProgressBar(
                  maxSteps: controller.totalSteps,
                  currentStep: controller.currentPage.value + 1,
                  progressType: ProgressType.linear,
                  progressColor: AppTheme.secondaryColor,

                  backgroundColor: AppTheme.surfaceHover,
                  borderRadius: BorderRadius.circular(10.r),
                  animateProgress: true,
                  animationDuration: Duration(milliseconds: 300),
                  animationCurve: Curves.easeInOut,
                  minHeight: 5.h,
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: (index) => controller.currentPage.value = index,
                children: [
                  OnboardContent1(),
                  OnboardContent2(),
                  OnboardContent3(),
                ],
              ),
            ),
            // Obx(
            //   () => Padding(
            //     padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 30.h),
            //     child: Align(
            //       alignment: Alignment.bottomRight,
            //       child: controller.currentPage.value == 2
            //           ? SizedBox.shrink()
            //           : MyIcon(
            //               onPressed: controller.goNextContent,
            //               backgroundColor: AppTheme.primaryColor,
            //               iconColor: Colors.white,
            //               icon: LucideIcons.arrowRight,
            //               iconSize: 30,
            //               padding: 20,
            //             ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
