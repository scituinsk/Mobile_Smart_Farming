import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/add_modul_ui_controller.dart';

class AddModulCodeInput extends StatelessWidget {
  final String title;
  final String hintText;
  const AddModulCodeInput({
    super.key,
    required this.title,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddModulUiController>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.r,
      children: [
        Expanded(
          child: MyTextField(
            title: "Kode Perangkat",
            controller: controller.modulCodeController,
            hint: "Ex: 018bd6f8-7d8b-7132-842b-3247e",
            fillColor: Colors.white,
            validator: controller.validateCode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.only(top: 25.h),
          child: MyIcon(
            icon: Icons.qr_code_rounded,
            iconColor: AppTheme.primaryColor,
            backgroundColor: Color(0xffBFD1B0),
            iconSize: 30,
            borderRadius: 10,
            padding: 12,
            onPressed: () {
              controller.openQrScanner();
            },
          ),
        ),
      ],
    );
  }
}
