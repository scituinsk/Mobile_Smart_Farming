import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class OnboardContent3 extends StatelessWidget {
  const OnboardContent3({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 46.0.w, left: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 18.r,
              children: [
                Text(
                  "Data Lahan,\nReal Time!",
                  style: AppTheme.onboardingTitle,
                ),
                Text(
                  "Pantau suhu, kelembapan, dan air langsung dari HP. Biar lahanmu selalu siap hasilin panen terbaik.",
                  style: AppTheme.h4.copyWith(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            "assets/svgs/onboard_3.svg",
            height: 400.h,
            width: 400.w,
          ),
          Container(
            width: double.infinity,
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: FilledButton(
              onPressed: () => Get.offAllNamed(RouteNamed.loginPage),
              child: Text("Mulai Aplikasi"),
            ),
          ),
        ],
      ),
    );
  }
}
