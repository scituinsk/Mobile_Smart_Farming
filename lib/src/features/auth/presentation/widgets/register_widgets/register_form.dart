import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/features/auth/presentation/widgets/register_widgets/register_form_input.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        RegisterFormInput(),
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
              child: MyFilledButton(title: "Login", onPressed: () {}),
            ),
          ],
        ),
      ],
    );
  }
}
