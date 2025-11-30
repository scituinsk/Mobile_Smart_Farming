import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_dialog.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/relays/domain/models/group_relay.dart';
import 'package:pak_tani/src/features/relays/domain/models/relay.dart';
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
                validator: controller.validateGroupName,
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
                  Obx(() {
                    final loading = controller.isLoading.value;
                    return FilledButton(
                      onPressed: !loading
                          ? () async => await controller.handleAddRelayGroup()
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
    ).then((_) => controller.disposeRelayGroupDialog());
  }

  static void showEditGroupModal(
    BuildContext context,
    RelayGroup relayGroup,
  ) async {
    RelayUiController controller = Get.find<RelayUiController>();

    controller.initEditGroupDialog(relayGroup);
    await CustomDialog.show(
      widthTitle: 240,
      context: context,
      title: Text("Ubah Nama Grub", style: AppTheme.h4),
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
                validator: controller.validateGroupName,
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
                  Obx(() {
                    final loading = controller.isLoading.value;
                    return FilledButton(
                      onPressed: !loading
                          ? () async => await controller
                                .handleEditRelayGroupName(relayGroup.id)
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
    controller.disposeRelayGroupDialog();
  }

  static void showEditRelayModal(BuildContext context, Relay relay) async {
    RelayUiController controller = Get.find<RelayUiController>();
    controller.initEditRelayDialog(relay.name, relay.descriptions);
    await CustomDialog.show(
      widthTitle: 240,
      context: context,
      title: Text("Ubah Relay", style: AppTheme.h4),
      child: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 10,
            children: [
              MyTextField(
                fieldWidth: 240,
                title: "Nama Relay",
                controller: controller.relayNameC,
                validator: controller.validateRelayName,
                hint: "Ex: Solenoid 1",
                borderRadius: 10,
                focusNode: controller.relayNameFocus,
              ),
              MyTextField(
                fieldWidth: 240,
                title: "Deskripsi Relay",
                controller: controller.relayDescC,
                hint: "Masukkan Deskripsi",
                borderRadius: 10,
                validator: controller.validateDescription,
                focusNode: controller.relayDescFocus,
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
                  Obx(() {
                    final loading = controller.isLoading.value;
                    return FilledButton(
                      onPressed: !loading
                          ? () =>
                                controller.handleEditRelay(relay.pin, relay.id)
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
    ).then((_) => controller.disposeEditRelayDialog());
  }

  static void showDeleteGroupModal(BuildContext context, int id) {
    final controller = Get.find<RelayUiController>();

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
                Obx(() {
                  final isLoading = controller.isLoading.value;
                  return MyFilledButton(
                    onPressed: isLoading
                        ? null
                        : () async => await controller.deleteRelayGroup(id),
                    backgroundColor: AppTheme.errorColor,
                    textColor: Colors.white,
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                            padding: EdgeInsets.all(5),
                          )
                        : Text("Hapus"),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
