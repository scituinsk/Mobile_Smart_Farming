import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/utils/log_utils.dart';
import 'package:pak_tani/src/features/auth/presentation/controller/auth_controller.dart';

class LoginUiController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late GlobalKey<FormState> formKey;

  final RxBool isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    formKey = GlobalKey<FormState>();

    // ✅ Add listeners to check form validity
    emailController.addListener(_checkFormValidity);
    passwordController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    emailController.removeListener(_checkFormValidity);
    passwordController.removeListener(_checkFormValidity);

    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ✅ Check if form is valid
  void _checkFormValidity() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Tambahkan validasi lengkap
    final emailValid =
        validateEmailandUsername(email) == null && email.isNotEmpty;
    final passwordValid =
        validatePassword(password) == null && password.isNotEmpty;

    isFormValid.value = emailValid && passwordValid;
    LogUtils.d("is valid: ${isFormValid.value}");
  }

  void handleLogin() {
    if (formKey.currentState!.validate()) {
      Get.find<AuthController>().login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    }
  }

  // ✅ Add email validation
  String? validateEmailandUsername(String? value) {
    if (value?.isEmpty ?? true) return 'validation_email_username_required'.tr;

    // Check if it looks like an email
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (emailRegex.hasMatch(value!)) {
      // Validate as email
      if (!emailRegex.hasMatch(value)) return 'validation_email_invalid'.tr;
    } else {
      // Validate as username (e.g., length and characters)
      if (value.length < 3) return 'validation_username_min_length'.tr;
      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
        return 'validation_username_invalid_chars'.tr;
      }
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) return 'validation_password_required'.tr;
    if (value!.length < 6) return 'validation_password_min_length'.tr;
    return null;
  }
}
