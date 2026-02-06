import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';

class RegisterLogo extends StatelessWidget {
  const RegisterLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5.h,
      children: [
        Column(
          spacing: 5.r,
          children: [
            CustomIcon(type: MyCustomIcon.logoPrimary, size: 105),
            Text("PAKTani", style: AppTheme.h2.copyWith()),
          ],
        ),
        Column(
          children: [
            Text(
              "Daftar Akun",
              style: AppTheme.h4.copyWith(color: AppTheme.primaryColor),
            ),
            Text(
              "Lengkapi data anda untuk membuat akun.",
              style: AppTheme.textAction,
            ),
          ],
        ),
      ],
    );
  }
}
