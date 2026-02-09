import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_checkbox.dart';
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
                title: "auth_first_name".tr,
                hint: "auth_first_name_hint".tr,
                borderRadius: 5,
                titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.edit, color: AppTheme.secondaryColor),
                validator: controller.validateFirstName,
              ),
              MyTextField(
                controller: controller.lastNameController,
                validator: controller.validateLastName,
                title: "auth_last_name".tr,
                hint: "auth_last_name_hint".tr,
                borderRadius: 5,
                titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.edit, color: AppTheme.secondaryColor),
              ),
              MyTextField(
                controller: controller.usernameController,
                title: "auth_username".tr,
                hint: "auth_username_hint".tr,
                borderRadius: 5,
                titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.person_rounded,
                  color: AppTheme.secondaryColor,
                ),
                validator: controller.validateUsername,
              ),
              MyTextField(
                controller: controller.emailController,
                title: "auth_email".tr,
                hint: "auth_email_hint".tr,
                borderRadius: 5,
                titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.email_rounded,
                  color: AppTheme.secondaryColor,
                ),
                validator: controller.validateEmail,
              ),
              MyTextField(
                controller: controller.passwordController,
                title: "auth_password".tr,
                obscureText: true,
                obscureIconColor: AppTheme.secondaryColor,
                hint: "auth_password_hint".tr,
                titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
                borderRadius: 5,
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.lock_rounded,
                  color: AppTheme.secondaryColor,
                ),
                validator: controller.validatePassword,
              ),
              MyTextField(
                controller: controller.confirmPasswordController,
                title: "auth_confirm_password".tr,
                obscureText: true,
                obscureIconColor: AppTheme.secondaryColor,
                hint: "auth_confirm_password_hint".tr,
                titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
                borderRadius: 5,
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.lock_rounded,
                  color: AppTheme.secondaryColor,
                ),
                validator: controller.validateConfirmPassword,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(
                    () => MyCheckbox(
                      value: controller.isAccept.value,
                      onChanged: (value) =>
                          controller.toggleTermsAndConditions(),
                    ),
                  ),
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("auth_i_agree".tr, style: AppTheme.textAction),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteNames.termsPage);
                          },
                          child: Text(
                            "auth_terms_conditions".tr,
                            style: AppTheme.textAction.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            spacing: 20.r,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(child: Text("auth_already_have_account".tr)),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          "auth_login_here".tr,
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
                  final isButtonDisabled =
                      authController.isLoading.value ||
                      !controller.isFormValid.value;

                  return MyFilledButton(
                    title: authController.isLoading.value
                        ? "auth_registering_btn".tr
                        : "auth_register_btn".tr,
                    onPressed: isButtonDisabled
                        ? null
                        : controller.handleRegister,
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
