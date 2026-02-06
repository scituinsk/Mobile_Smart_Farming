import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/auth/presentation/controller/auth_controller.dart';
import 'package:pak_tani/src/features/auth/presentation/controller/login_ui_controller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginUiController());

    return Form(
      key: controller.formKey,
      child: Column(
        spacing: 20.r,
        children: [
          Column(
            spacing: 3.r,
            children: [
              Column(
                spacing: 15.r,
                children: [
                  MyTextField(
                    title: "Username atau Email",
                    controller: controller.emailController,
                    hint: "Masukkan username atau email anda...",
                    borderRadius: 5,
                    titleStyle: AppTheme.h5.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.email_rounded,
                      color: AppTheme.secondaryColor,
                    ),
                    validator:
                        controller.validateEmailandUsername, // ✅ Add validation
                  ),
                  MyTextField(
                    controller: controller.passwordController,
                    validator: controller.validatePassword,
                    title: "Password",
                    obscureText: true,
                    obscureIconColor: AppTheme.secondaryColor,
                    hint: "Masukkan password anda...",
                    titleStyle: AppTheme.h5.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                    borderRadius: 5,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.lock_rounded,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),

              // Align(
              //   alignment: Alignment.centerRight,
              //   child: GestureDetector(
              //     child: Text(
              //       "Lupa password?",
              //       style: AppTheme.text.copyWith(color: AppTheme.primaryColor),
              //     ),
              //   ),
              // ),
            ],
          ),
          Column(
            spacing: 20.r,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(child: Text("Belum punya akun? ")),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteNames.registerPage);
                        },
                        child: Text(
                          "Daftar akun",
                          style: AppTheme.textMedium.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  // ✅ Business Controller - dari DI
                  final authController = Get.find<AuthController>();

                  return MyFilledButton(
                    onPressed:
                        (!authController.isLoading.value &&
                            controller.isFormValid.value)
                        ? controller.handleLogin
                        : null,

                    child: authController.isLoading.value
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
