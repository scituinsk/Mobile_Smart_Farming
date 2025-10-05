import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/features/auth/presentation/widgets/login_widgets/login_form.dart';
import 'package:pak_tani/src/features/auth/presentation/widgets/login_widgets/login_logo.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double mediaQueryWidth = Get.width;
    final double mediaQueryHeight = Get.height;
    return Scaffold(
      appBar: AppBar(leading: Center(child: MyBackButton()), leadingWidth: 100),
      body: Container(
        width: mediaQueryWidth,
        height: mediaQueryHeight,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(spacing: 32, children: [LoginLogo(), LoginForm()]),
        ),
      ),
    );
  }
}
