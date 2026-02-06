import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/features/auth/presentation/widgets/register_widgets/register_form.dart';
import 'package:pak_tani/src/features/auth/presentation/widgets/register_widgets/register_logo.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double mediaQueryWidth = Get.width;
    final double mediaQueryHeight = Get.height;
    return Scaffold(
      appBar: AppBar(leading: Center(child: MyBackButton()), leadingWidth: 100),
      body: SafeArea(
        child: Container(
          width: mediaQueryWidth,
          height: mediaQueryHeight,
          padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 15.r,
              children: [RegisterLogo(), RegisterForm()],
            ),
          ),
        ),
      ),
    );
  }
}
