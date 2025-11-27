import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_dialog.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/relays/presentation/controllers/relay_ui_controller.dart';

class RelayModals {
  static void showAddModal(BuildContext context) {
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

  static void showEditGroupModal(BuildContext context) {
    RelayUiController controller = Get.find<RelayUiController>();

    CustomDialog.show(
      widthTitle: 240,
      context: context,
      title: Text("Ubah Nama Grub", style: AppTheme.h4),
      child: SingleChildScrollView(
        child: Form(
          // key: controller.formKey,
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
                      // onPressed: !loading
                      //     ? () => controller.handleAddRelayGroup()
                      //     : null,
                      onPressed: () {},
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

  static void showEditRelayModal(BuildContext context) {
    RelayUiController controller = Get.find<RelayUiController>();

    CustomDialog.show(
      widthTitle: 240,
      context: context,
      title: Text("Ubah Relay", style: AppTheme.h4),
      child: SingleChildScrollView(
        child: Form(
          // key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 10,
            children: [
              MyTextField(
                fieldWidth: 240,
                title: "Nama Relay",
                // controller: controller.groupName,
                // validator: controller.validateName,
                hint: "Ex: Solenoid 1",
                borderRadius: 10,
              ),
              MyTextField(
                fieldWidth: 240,
                title: "Deskripsi Relay",
                // controller: controller.groupName,
                // validator: controller.validateName,
                hint: "Masukkan Deskripsi",
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
                      // controller.groupName.text = "";
                    },
                    backgroundColor: AppTheme.surfaceColor,
                    title: "Batal",
                    textColor: AppTheme.primaryColor,
                  ),
                  Obx(() {
                    final loading = controller.isLoading.value;
                    return FilledButton(
                      // onPressed: !loading
                      //     ? () => controller.handleAddRelayGroup()
                      //     : null,
                      onPressed: () {},
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

  static void showDeleteGroupModal(BuildContext context) {
    CustomDialog.show(
      context: context,
      dialogMargin: 35,
      widthTitle: double.infinity,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline_rounded,
              color: AppTheme.errorColor,
              size: 38,
            ),
            Text("Hapus Grub ini?", style: AppTheme.h4),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Grub ini akan dihapus dari daftar relay.",
              textAlign: TextAlign.center,
              style: AppTheme.textDefault,
            ),
            Row(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyFilledButton(
                  title: "Batal",
                  onPressed: () {
                    Get.back();
                  },
                  backgroundColor: AppTheme.surfaceColor,
                  textColor: AppTheme.primaryColor,
                ),
                MyFilledButton(
                  title: "Hapus",
                  onPressed: () {
                    Get.back();
                  },
                  backgroundColor: AppTheme.errorColor,
                  textColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
