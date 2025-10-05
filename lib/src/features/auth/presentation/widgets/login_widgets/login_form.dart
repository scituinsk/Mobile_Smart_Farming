import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/features/auth/presentation/widgets/login_widgets/login_form_input.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Column(
          spacing: 3,
          children: [
            LoginFormInput(),
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
                    style: AppTheme.text.copyWith(color: AppTheme.primaryColor),
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
              child: MyFilledButton(title: "Login", onPressed: () {}),
            ),
          ],
        ),
      ],
    );
  }
}
