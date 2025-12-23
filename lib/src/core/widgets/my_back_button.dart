import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: () => Get.back(canPop: true, closeOverlays: false),
      icon: Icon(Icons.keyboard_arrow_left_rounded),
      iconSize: 30.r,
      padding: EdgeInsets.all(2.r),
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all(AppTheme.primaryColor),
        backgroundColor: WidgetStateProperty.all(Colors.white),
      ),
    );
  }
}
