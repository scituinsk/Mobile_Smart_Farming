import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/config/app_config.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_dialog.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_detail_ui_controller.dart';

class MenuItem {
  final String text;
  final IconData icon;
  const MenuItem({required this.text, required this.icon});
}

abstract class ModulDetailDropdownMenuItems {
  static const modulLogs = MenuItem(
    text: "Riwayat Modul",
    icon: LucideIcons.scrollText,
  );
  static const editIcon = MenuItem(text: "Edit Modul", icon: Icons.edit);
  static const deleteIcon = MenuItem(
    text: "Delete Modul",
    icon: Icons.delete_rounded,
  );
  static const editPasswordIcon = MenuItem(
    text: "Edit password",
    icon: Icons.key,
  );

  static const List<MenuItem> items = [
    modulLogs,
    editIcon,
    editPasswordIcon,
    deleteIcon,
  ];

  static Widget buildItem(MenuItem item) {
    return item == deleteIcon
        ? Row(
            spacing: 15,
            children: [
              MyIcon(
                icon: item.icon,
                backgroundColor: AppTheme.errorColor,
                iconColor: Colors.white,
                iconSize: 16,
              ),
              Text(
                item.text,
                style: AppTheme.text.copyWith(color: AppTheme.errorColor),
              ),
            ],
          )
        : Row(
            spacing: 15,
            children: [
              MyIcon(
                icon: item.icon,
                backgroundColor: AppTheme.surfaceColor,
                iconSize: 16,
              ),
              Text(
                item.text,
                style: AppTheme.text.copyWith(color: AppTheme.textColor),
              ),
            ],
          );
  }

  static Future<void> _showImageSourceBottomSheet(BuildContext context) async {
    final controller = Get.find<ModulDetailUiController>();
    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Pilih Sumber Gambar', style: AppTheme.h4),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppTheme.primaryColor),
                title: Text('Kamera', style: AppTheme.text),
                onTap: () async {
                  Get.back();
                  await controller.pickAndCropImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: AppTheme.primaryColor,
                ),
                title: Text('Galeri', style: AppTheme.text),
                onTap: () async {
                  Get.back();
                  await controller.pickAndCropImage(ImageSource.gallery);
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    final controller = Get.find<ModulDetailUiController>();

    switch (item) {
      case ModulDetailDropdownMenuItems.editIcon:
        controller.selectedImage.value = null;
        CustomDialog.show(
          widthTitle: double.infinity,
          widthChild: double.infinity,
          dialogMargin: 20,
          context: context,
          title: Text("Edit Modul", style: AppTheme.h4),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKeyEdit,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  MyTextField(
                    fieldWidth: double.infinity,
                    title: "Nama Modul",
                    validator: controller.validateName,
                    controller: controller.modulNameC,
                    hint: "Ex: Green House A",
                    borderRadius: 10,
                  ),
                  MyTextField(
                    fieldWidth: double.infinity,
                    title: "Deskripsi Modul",
                    controller: controller.modulDescriptionC,
                    hint: "Ex: Green house timur",
                    borderRadius: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Gambar Modul", style: AppTheme.h4),
                      Stack(
                        children: [
                          Obx(() {
                            final modul = controller.modul.value;
                            final selectedImage =
                                controller.selectedImage.value;
                            late ImageProvider imageProvider;
                            if (selectedImage == null) {
                              if (modul != null) {
                                imageProvider = modul.image != null
                                    ? NetworkImage(
                                        (AppConfig.baseUrl + modul.image!),
                                      )
                                    : const AssetImage(
                                        'assets/image/default_modul.jpg',
                                      );
                              } else {
                                imageProvider = const AssetImage(
                                  'assets/image/default_modul.jpg',
                                );
                              }
                            } else {
                              imageProvider = FileImage(selectedImage);
                            }

                            return Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 164,
                              width: 240,
                              child: Image(image: imageProvider),
                            );
                          }),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: MyIcon(
                              icon: Icons.edit,
                              backgroundColor: AppTheme.primaryColor,
                              iconColor: Colors.white,
                              padding: 6,
                              onPressed: () {
                                _showImageSourceBottomSheet(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyFilledButton(
                        onPressed: () {
                          Get.back();
                        },
                        backgroundColor: Colors.white,
                        title: "Batal",
                        textColor: AppTheme.primaryColor,
                      ),
                      Obx(() {
                        final enabled = controller.isEditFormValid.value;
                        final loading = controller.isSubmitting.value;
                        return FilledButton(
                          onPressed: enabled && !loading
                              ? () => controller.handleEditModul()
                              : null,
                          child: loading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
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
        break;
      case ModulDetailDropdownMenuItems.deleteIcon:
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
                  color: AppTheme.primaryColor,
                  size: 38,
                ),
                Text("Hapus Modul ini?", style: AppTheme.h4),
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
                  "Item modul ini akan dihapus dari daftar modul.",
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
                        final controller = Get.find<ModulDetailUiController>();
                        controller.deleteDevice();
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
        break;
      case ModulDetailDropdownMenuItems.editPasswordIcon:
        controller.isPasswordFormValid.value = false;
        CustomDialog.show(
          widthTitle: 240,
          // height: 300,
          context: context,
          title: Text("Edit password", style: AppTheme.h4),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKeyPassword,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 10,
                children: [
                  MyTextField(
                    fieldWidth: 240,
                    title: "Password baru",
                    controller: controller.modulNewPassC,
                    validator: controller.validatePassword,
                    hint: "Ex: PakTani1",
                    borderRadius: 10,
                  ),
                  MyTextField(
                    fieldWidth: 240,
                    title: "Konfirmasi password",
                    controller: controller.modulConfirmNewPassC,
                    validator: controller.validateConfirmPassword,
                    hint: "Ex: PakTani1",
                    borderRadius: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyFilledButton(
                        onPressed: () {
                          Get.back();
                        },
                        backgroundColor: Colors.white,
                        title: "Batal",
                        textColor: AppTheme.primaryColor,
                      ),
                      Obx(() {
                        final enabled = controller.isPasswordFormValid.value;
                        final loading = controller.isSubmitting.value;
                        return FilledButton(
                          onPressed: enabled && !loading
                              ? () => controller.handleEditPassword()
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
        break;
      case ModulDetailDropdownMenuItems.modulLogs:
        print("belum ada apa-apa");
    }
  }
}
