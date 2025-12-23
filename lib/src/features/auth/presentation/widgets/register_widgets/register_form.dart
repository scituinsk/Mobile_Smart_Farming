import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/auth/presentation/controller/auth_controller.dart';
import 'package:pak_tani/src/features/auth/presentation/controller/register_ui_controller.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterUiController());
    return Form(
      key: controller.formKey,
      child: Column(
        spacing: 20.r,
        children: [
          Column(
            spacing: 10.r,
            children: [
              MyTextField(
                controller: controller.firstNameController,
                title: "Nama Depan",
                hint: "Masukkan nama depan anda...",
                borderRadius: 5,
                titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor),
                validator: controller.validateFirstName,
              ),
              MyTextField(
                controller: controller.lastNameController,
                title: "Nama Belakang (opsional)",
                hint: "Masukkan nama belakang anda...",
                borderRadius: 5,
                titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor),
              ),
              MyTextField(
                controller: controller.usernameController,
                title: "Username",
                hint: "Masukkan username anda...",
                borderRadius: 5,
                titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.person_rounded,
                  color: AppTheme.primaryColor,
                ),
                validator: controller.validateUsername,
              ),
              MyTextField(
                controller: controller.emailController,
                title: "Alamat Email",
                hint: "Masukkan alamat email anda...",
                borderRadius: 5,
                titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.email_rounded,
                  color: AppTheme.primaryColor,
                ),
                validator: controller.validateEmail,
              ),
              MyTextField(
                controller: controller.passwordController,
                title: "Password",
                obscureText: true,
                hint: "Masukkan password anda...",
                titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
                borderRadius: 5,
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.lock_rounded,
                  color: AppTheme.primaryColor,
                ),
                validator: controller.validatePassword,
              ),
              MyTextField(
                controller: controller.confirmPasswordController,
                title: "Konfirmasi Password",
                obscureText: true,
                hint: "Konfirmasi password anda...",
                titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
                borderRadius: 5,
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.lock_rounded,
                  color: AppTheme.primaryColor,
                ),
                validator: controller.validateConfirmPassword,
              ),
            ],
          ),
          Column(
            spacing: 20.r,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(child: Text("Sudah punya akun?")),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => Get.toNamed(RouteNamed.loginPage),
                        child: Text(
                          " Login disini",
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
              Container(
                padding: EdgeInsets.only(bottom: 15.h),
                width: double.infinity,
                child: Obx(() {
                  final authController = Get.find<AuthController>();
                  // ✅ FIX: Logic yang benar untuk button disable
                  final isButtonDisabled =
                      authController.isLoading.value ||
                      !controller.isFormValid.value; // ✅ FIXED: tambah !

                  return MyFilledButton(
                    title: authController.isLoading.value
                        ? "Mendaftar..."
                        : "Daftar",
                    onPressed: isButtonDisabled
                        ? null
                        : controller.handleRegister,
                    backgroundColor: isButtonDisabled
                        ? Colors.grey[400]!
                        : AppTheme.primaryColor,
                    textColor: Colors.white,
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
