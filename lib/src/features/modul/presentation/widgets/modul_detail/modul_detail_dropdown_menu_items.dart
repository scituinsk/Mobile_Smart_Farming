import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/config/app_config.dart';
import 'package:pak_tani/src/core/controllers/main_navigation_controller.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_dialog.dart';
import 'package:pak_tani/src/core/utils/image_utils.dart';
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
    text: "Riwayat Perangkat",
    icon: LucideIcons.scrollText,
  );
  static const editIcon = MenuItem(text: "Edit Perangkat", icon: Icons.edit);
  static const deleteIcon = MenuItem(
    text: "Hapus Perangkat",
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
            spacing: 10.r,
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
            spacing: 10.r,

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

  static void onChanged(BuildContext context, MenuItem item) {
    final controller = Get.find<ModulDetailUiController>();

    switch (item) {
      case ModulDetailDropdownMenuItems.editIcon:
        controller.selectedImage.value = null;
        CustomDialog.show(
          widthChild: double.infinity,
          dialogMargin: 20,
          context: context,
          title: Row(
            spacing: 10.w,
            children: [
              Icon(LucideIcons.squarePen, color: AppTheme.primaryColor),
              Text("Edit Perangkat", style: AppTheme.h4),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKeyEdit,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.r,
                children: [
                  MyTextField(
                    fieldWidth: double.infinity,
                    title: "Nama Perangkat",
                    validator: controller.validateName,
                    controller: controller.modulNameC,
                    hint: "Ex: Greenhouse A",
                    borderRadius: 10,
                  ),
                  MyTextField(
                    fieldWidth: double.infinity,
                    title: "Deskripsi Perangkat",
                    controller: controller.modulDescriptionC,
                    hint: "Ex: Greenhouse timur",
                    borderRadius: 10,
                    validator: controller.validateDescription,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Gambar Perangkat", style: AppTheme.h4),
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
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              height: 164.h,
                              width: 240.w,
                              child: Image(
                                image: imageProvider,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                              ),
                            );
                          }),
                          Positioned(
                            right: 8.w,
                            top: 8.h,
                            child: MyIcon(
                              icon: Icons.edit,
                              backgroundColor: AppTheme.primaryColor,
                              iconColor: Colors.white,
                              padding: 6,
                              onPressed: () async {
                                final croppedImage =
                                    await ImageUtils.showImageSourceAndPick(
                                      context,
                                    );
                                if (croppedImage != null) {
                                  controller.selectedImage.value = croppedImage;
                                }
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
                        onPressed: () => Get.back(),
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
                                  width: 20.w,
                                  height: 20.h,
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
            padding: EdgeInsets.only(bottom: 5.h),
            child: Column(
              spacing: 8.r,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.trash2,
                  color: AppTheme.errorColor,
                  size: 38.r,
                ),
                Text("Hapus Perangkat dari akun?", style: AppTheme.h4),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 38.w),
            child: Column(
              spacing: 20.r,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Perangkat ini akan dihapus dari daftar Perangkat di akun ini.",
                  textAlign: TextAlign.center,
                  style: AppTheme.textDefault,
                ),
                Row(
                  spacing: 15.r,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyFilledButton(
                      title: "Batal",
                      onPressed: () {
                        Get.back();
                      },
                      backgroundColor: AppTheme.surfaceColor,
                      textColor: AppTheme.surfaceDarker,
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
          dialogMargin: 40,
          context: context,
          title: Row(
            spacing: 10.w,
            children: [
              Icon(Icons.lock_outline, color: AppTheme.primaryColor),
              Text("Edit password", style: AppTheme.h4),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKeyPassword,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 10.r,
                children: [
                  MyTextField(
                    // fieldWidth: 240,
                    title: "Password baru",
                    controller: controller.modulNewPassC,
                    validator: controller.validatePassword,
                    hint: "Ex: PakTani1",
                    borderRadius: 10,
                  ),
                  MyTextField(
                    // fieldWidth: 240,
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
                                  padding: EdgeInsets.all(5.r),
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
        Get.back();

        final mainNavController = Get.find<MainNavigationController>();
        mainNavController.modulIdArg = controller.modul.value;
        mainNavController.navigateToHistory();
    }
  }
}
