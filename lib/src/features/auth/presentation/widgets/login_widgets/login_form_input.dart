import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';

class LoginFormInput extends StatelessWidget {
  const LoginFormInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        MyTextField(
          title: "Username atau Email",
          hint: "Masukkan username atau email anda...",
          borderRadius: 5,
          titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.email_rounded, color: AppTheme.primaryColor),
        ),
        MyTextField(
          title: "Password",
          obscureText: true,
          hint: "Masukkan password anda...",
          titleStyle: AppTheme.h5.copyWith(color: AppTheme.primaryColor),
          borderRadius: 5,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.lock_rounded, color: AppTheme.primaryColor),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(Icons.visibility_off, color: AppTheme.primaryColor),
          ),
        ),
      ],
    );
  }
}
