import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_dialog.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';

class RelayAddModal {
  static void show(BuildContext context) {
    CustomDialog.show(
      widthTitle: 240,
      // height: 300,
      context: context,
      title: Text("Tambah Grub Baru", style: AppTheme.h4),
      child: SingleChildScrollView(
        child: Form(
          // key: controller.formKeyPassword,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 10,
            children: [
              MyTextField(
                fieldWidth: 240,
                title: "Nama Grub",
                // controller: controller.modulNewPassC,
                // validator: controller.validatePassword,
                hint: "Ex: GreenH 1",
                borderRadius: 10,
              ),
              Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyFilledButton(
                    onPressed: () {
                      Get.back();
                    },
                    backgroundColor: AppTheme.surfaceColor,
                    title: "Batal",
                    textColor: AppTheme.primaryColor,
                  ),
                  // Obx(() {
                  //   final enabled = controller.isPasswordFormValid.value;
                  //   final loading = controller.isSubmitting.value;
                  //   return FilledButton(
                  //     onPressed: enabled && !loading
                  //         ? () => controller.handleEditPassword()
                  //         : null,
                  //     child: loading
                  //         ? CircularProgressIndicator(
                  //             padding: EdgeInsets.all(5),
                  //           )
                  //         : Text("Simpan"),
                  //   );
                  // }),
                  FilledButton(onPressed: () {}, child: Text("Simpan")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
