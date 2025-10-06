import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/auth/presentation/controller/auth_controller.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // Form controllers
  late TextEditingController firstNameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late GlobalKey<FormState> formKey;

  // UI state
  final RxBool isFormValid = false.obs; // ✅ Add form validation state

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    formKey = GlobalKey<FormState>();

    // ✅ Add listeners to check form validity
    firstNameController.addListener(_checkFormValidity);
    usernameController.addListener(_checkFormValidity);
    emailController.addListener(_checkFormValidity);
    passwordController.addListener(_checkFormValidity);
    confirmPasswordController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    // ✅ Remove listeners before disposing
    firstNameController.removeListener(_checkFormValidity);
    usernameController.removeListener(_checkFormValidity);
    emailController.removeListener(_checkFormValidity);
    passwordController.removeListener(_checkFormValidity);
    confirmPasswordController.removeListener(_checkFormValidity);

    firstNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // ✅ Check if form is valid
  void _checkFormValidity() {
    final firstName = firstNameController.text.trim();
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    isFormValid.value =
        firstName.isNotEmpty &&
        username.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty;
  }

  // Validation methods
  String? _validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.trim().length < 2) {
      return 'Nama minimal 2 karakter';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Username minimal 3 karakter';
    }
    // Check for valid username format (alphanumeric and underscore only)
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
      return 'Username hanya boleh mengandung huruf, angka, dan underscore';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    // Email regex pattern
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password harus mengandung minimal 1 huruf besar';
    }
    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password harus mengandung minimal 1 huruf kecil';
    }
    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password harus mengandung minimal 1 angka';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // Register handler
  void _handleRegister() async {
    if (formKey.currentState!.validate()) {
      final authController = Get.find<AuthController>();

      await authController.register(
        firstName: firstNameController.text.trim(),
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password1: passwordController.text,
        password2: confirmPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 20,
        children: [
          Column(
            spacing: 10,
            children: [
              MyTextField(
                controller: firstNameController,
                title: "Nama",
                hint: "Masukkan nama anda...",
                borderRadius: 5,
                titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.edit, color: AppTheme.primaryColor),
                validator: _validateFirstName,
              ),
              MyTextField(
                controller: usernameController,
                title: "Username",
                hint: "Masukkan username anda...",
                borderRadius: 5,
                titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.person_rounded,
                  color: AppTheme.primaryColor,
                ),
                validator: _validateUsername,
              ),
              MyTextField(
                controller: emailController,
                title: "Alamat Email",
                hint: "Masukkan alamat email anda...",
                borderRadius: 5,
                titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.email_rounded,
                  color: AppTheme.primaryColor,
                ),
                validator: _validateEmail,
              ),
              MyTextField(
                controller: passwordController,
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
                validator: _validatePassword,
              ),
              MyTextField(
                controller: confirmPasswordController,
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
                validator: _validateConfirmPassword,
              ),
            ],
          ),
          Column(
            spacing: 20,
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
                padding: EdgeInsets.only(bottom: 15),
                width: double.infinity,
                child: Obx(() {
                  final authController = Get.find<AuthController>();
                  final isButtonDisabled =
                      authController.isLoading.value || !isFormValid.value;

                  return MyFilledButton(
                    title: authController.isLoading.value
                        ? "Mendaftar..."
                        : "Daftar",
                    // ✅ Disable button if loading OR form is invalid
                    onPressed: isButtonDisabled ? null : _handleRegister,
                    // ✅ Change button color when disabled
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
