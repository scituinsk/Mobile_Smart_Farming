import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
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
        spacing: 20,
        children: [
          Column(
            spacing: 3,
            children: [
              Column(
                spacing: 15,
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
                      color: AppTheme.primaryColor,
                    ),
                    validator: controller.validateEmail, // ✅ Add validation
                  ),
                  MyTextField(
                    controller: controller.passwordController,
                    validator: controller.validatePassword,
                    title: "Password",
                    obscureText: true,
                    hint: "Masukkan password anda...",
                    titleStyle: AppTheme.h5.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                    borderRadius: 5,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.lock_rounded,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(
                        () => Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (value) => controller.toggleRememberMe(),
                        ),
                      ),
                      Text("Ingat Saya"),
                    ],
                  ),
                  GestureDetector(
                    child: Text(
                      "Lupa password?",
                      style: AppTheme.text.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            spacing: 20,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(child: Text("Belum punya akun?")),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteNamed.registerPage);
                        },
                        child: Text(
                          " Daftar akun",
                          style: AppTheme.text.copyWith(
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

                  return FilledButton(
                    // ✅ Disable button if loading OR form is invalid
                    onPressed:
                        (authController.isLoading.value ||
                            !controller.isFormValid.value)
                        ? null
                        : controller.handleLogin,
                    style: FilledButton.styleFrom(
                      // ✅ Change button color based on state
                      backgroundColor:
                          (authController.isLoading.value ||
                              !controller.isFormValid.value)
                          ? Colors.grey[400]
                          : AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: authController.isLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
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
