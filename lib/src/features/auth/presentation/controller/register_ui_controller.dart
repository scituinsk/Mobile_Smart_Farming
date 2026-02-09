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
      return 'validation_first_name_required'.tr;
    }
    if (value.trim().length < 2) {
      return 'validation_first_name_min_length'.tr;
    }
    if (value.trim().length > 255) {
      return 'validation_name_max_length'.tr;
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (value.trim().length > 255) {
      return 'validation_name_max_length'.tr;
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation_username_required'.tr;
    }
    if (value.trim().length < 3) {
      return 'validation_username_min_3_chars'.tr;
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
      return 'validation_username_chars'.tr;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation_email_required'.tr;
    }
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value.trim())) {
      return 'validation_email_format'.tr;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation_password_required'.tr;
    }
    if (value.length < 8) {
      return 'validation_password_min_8'.tr;
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'validation_password_uppercase'.tr;
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'validation_password_lowercase'.tr;
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'validation_password_number'.tr;
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation_confirm_password_required'.tr;
    }
    if (value != passwordController.text) {
      return 'validation_password_mismatch'.tr;
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
