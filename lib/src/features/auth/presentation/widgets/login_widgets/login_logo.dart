import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15.r,
      children: [
        Column(
          spacing: 5.r,
          children: [
            CustomIcon(type: MyCustomIcon.logoPrimary, size: 105),
            Text(
              "PAKTani",
              style: AppTheme.h2.copyWith(color: AppTheme.primaryColor),
            ),
          ],
        ),
        RichText(
          text: TextSpan(
            style: AppTheme.text,
            children: [
              WidgetSpan(
                child: Text(
                  "Masuk ",
                  style: AppTheme.text.copyWith(color: AppTheme.primaryColor),
                ),
              ),
              WidgetSpan(child: Text("ke akun anda")),
            ],
          ),
        ),
      ],
    );
  }
}
