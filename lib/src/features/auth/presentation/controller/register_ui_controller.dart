import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/features/auth/presentation/controller/auth_controller.dart';

class RegisterUiController extends GetxController {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late GlobalKey<FormState> formKey;

  final RxBool isFormValid = false.obs;
  final RxBool isAccept = false.obs;

  @override
  void onInit() {
    super.onInit();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    formKey = GlobalKey<FormState>();

    // Add listeners to check form validity
    firstNameController.addListener(_checkFormValidity);
    usernameController.addListener(_checkFormValidity);
    emailController.addListener(_checkFormValidity);
    passwordController.addListener(_checkFormValidity);
    confirmPasswordController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    firstNameController.removeListener(_checkFormValidity);
    usernameController.removeListener(_checkFormValidity);
    emailController.removeListener(_checkFormValidity);
    passwordController.removeListener(_checkFormValidity);
    confirmPasswordController.removeListener(_checkFormValidity);

    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    final firstNameError = validateFirstName(firstNameController.text);
    final lastNameError = validateLastName(lastNameController.text);
    final usernameError = validateUsername(usernameController.text);
    final emailError = validateEmail(emailController.text);
    final passwordError = validatePassword(passwordController.text);
    final confirmPasswordError = validateConfirmPassword(
      confirmPasswordController.text,
    );

    isFormValid.value =
        firstNameError == null &&
        usernameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        lastNameError == null &&
        isAccept.value;
  }

  void clearForm() {
    firstNameController.clear();
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    isFormValid.value = false;
  }

  // Validation methods (keep existing ones)
  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.trim().length < 2) {
      return 'Nama minimal 2 karakter';
    }
    if (value.trim().length > 255) {
      return "Nama maksimal 255 karakter";
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (value.trim().length > 255) {
      return "Nama maksimal 255 karakter";
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Username minimal 3 karakter';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
      return 'Username hanya boleh mengandung huruf, angka, dan underscore';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password harus mengandung minimal 1 huruf besar';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password harus mengandung minimal 1 huruf kecil';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password harus mengandung minimal 1 angka';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // Register handler
  void handleRegister() async {
    if (formKey.currentState!.validate()) {
      final authController = Get.find<AuthController>();

      await authController.register(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password1: passwordController.text,
        password2: confirmPasswordController.text,
      );
    }
  }

  void toggleTermsAndConditions() {
    isAccept.value = !isAccept.value;
    _checkFormValidity();
  }
}
