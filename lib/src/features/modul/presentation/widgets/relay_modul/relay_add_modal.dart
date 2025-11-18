import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_dialog.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/relay_ui_controller.dart';

class RelayAddModal {
  static void show(BuildContext context) {
    RelayUiController controller = Get.find<RelayUiController>();

    CustomDialog.show(
      widthTitle: 240,
      context: context,
      title: Text("Tambah Grub Baru", style: AppTheme.h4),
      child: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 10,
            children: [
              MyTextField(
                fieldWidth: 240,
                title: "Nama Grub",
                controller: controller.groupName,
                validator: controller.validateName,
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
                      controller.groupName.text = "";
                    },
                    backgroundColor: AppTheme.surfaceColor,
                    title: "Batal",
                    textColor: AppTheme.primaryColor,
                  ),
                  Obx(() {
                    final loading = controller.isLoading.value;
                    return FilledButton(
                      onPressed: !loading
                          ? () => controller.handleAddRelayGroup()
                          : null,
                      child: loading
                          ? CircularProgressIndicator(
                              padding: EdgeInsets.all(5),
                            )
                          : Text("Simpan"),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
