import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/features/auth/presentation/widgets/login_widgets/login_form.dart';
import 'package:pak_tani/src/features/auth/presentation/widgets/login_widgets/login_logo.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double mediaQueryWidth = Get.width;
    final double mediaQueryHeight = Get.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: mediaQueryWidth,
          height: mediaQueryHeight,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: SingleChildScrollView(
            child: Column(spacing: 32, children: [LoginLogo(), LoginForm()]),
          ),
        ),
      ),
    );
  }
}
