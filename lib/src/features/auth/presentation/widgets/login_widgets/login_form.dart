import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/auth/presentation/controller/auth_controller.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late GlobalKey<FormState> formKey;

  final RxBool isFormValid = false.obs; // ✅ Add form validation state

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    formKey = GlobalKey<FormState>();

    // ✅ Add listeners to check form validity
    emailController.addListener(_checkFormValidity);
    passwordController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    // ✅ Remove listeners before disposing
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
                    controller: emailController,
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
                    validator: _validateEmail, // ✅ Add validation
                  ),
                  Obx(
                    () => MyTextField(
                      controller: passwordController,
                      validator: _validatePassword,
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
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(value: true, onChanged: (value) {}),
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
                  final authController = Get.find<AuthController>();

                  return FilledButton(
                    // ✅ Disable button if loading OR form is invalid
                    onPressed:
                        (authController.isLoading.value || !isFormValid.value)
                        ? null
                        : _handleLogin,
                    style: FilledButton.styleFrom(
                      // ✅ Change button color based on state
                      backgroundColor:
                          (authController.isLoading.value || !isFormValid.value)
                          ? Colors.grey[400]
                          : AppTheme.primaryColor,
                    ),
                    child: authController.isLoading.value
                        ? Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
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

  void _handleLogin() {
    if (formKey.currentState!.validate()) {
      Get.find<AuthController>().login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    }
  }

  // ✅ Add email validation
  String? _validateEmail(String? value) {
    if (value?.isEmpty ?? true) return 'Email atau username tidak boleh kosong';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value?.isEmpty ?? true) return 'Password tidak boleh kosong';
    if (value!.length < 6) return 'Password minimal 6 karakter';
    return null;
  }
}
