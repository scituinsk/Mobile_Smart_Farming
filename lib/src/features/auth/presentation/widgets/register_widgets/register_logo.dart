import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';

class RegisterLogo extends StatelessWidget {
  const RegisterLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Column(
          spacing: 2,
          children: [
            CustomIcon(type: MyCustomIcon.logoPrimary, size: 105),
            Text(
              "PAKTani",
              style: AppTheme.h2.copyWith(color: AppTheme.primaryColor),
            ),
          ],
        ),
        RichText(
          text: TextSpan(
            style: AppTheme.text,
            children: [
              WidgetSpan(
                child: Text(
                  "Selamat Datang! ",
                  style: AppTheme.text.copyWith(color: AppTheme.primaryColor),
                ),
              ),
              WidgetSpan(child: Text("Silahkan buat akun anda")),
            ],
          ),
        ),
      ],
    );
  }
}
