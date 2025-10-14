import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/features/auth/presentation/controller/auth_controller.dart';

class LoginUiController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late GlobalKey<FormState> formKey;

  final RxBool isFormValid = false.obs;
  final RxBool rememberMe = false.obs;

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

    isFormValid.value = email.isNotEmpty && password.isNotEmpty;
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
  String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) return 'Email atau username tidak boleh kosong';
    return null;
  }

  String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) return 'Password tidak boleh kosong';
    if (value!.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }
}
