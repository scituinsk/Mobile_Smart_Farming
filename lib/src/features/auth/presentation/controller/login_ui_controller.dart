import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    print("is valid: ${isFormValid.value}");
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
    if (value?.isEmpty ?? true) return 'Email atau username tidak boleh kosong';

    // Check if it looks like an email
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (emailRegex.hasMatch(value!)) {
      // Validate as email
      if (!emailRegex.hasMatch(value)) return 'Format email tidak valid';
    } else {
      // Validate as username (e.g., length and characters)
      if (value.length < 3) return 'Username minimal 3 karakter';
      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
        return 'Username hanya boleh berisi huruf, angka, dan underscore';
      }
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) return 'Password tidak boleh kosong';
    if (value!.length < 6) return 'Password minimal 6 karakter';
    return null;
  }
}
