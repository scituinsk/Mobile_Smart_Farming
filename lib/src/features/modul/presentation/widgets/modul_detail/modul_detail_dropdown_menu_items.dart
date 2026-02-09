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

enum MenuType { logs, edit, delete, editPassword }

class MenuItem {
  final String text;
  final IconData icon;
  final MenuType type;
  const MenuItem({required this.text, required this.icon, required this.type});
}

abstract class ModulDetailDropdownMenuItems {
  static MenuItem get modulLogs => MenuItem(
    text: "device_history_menu".tr,
    icon: LucideIcons.scrollText,
    type: MenuType.logs,
  );
  static MenuItem get editIcon => MenuItem(
    text: "edit_device_menu".tr,
    icon: Icons.edit,
    type: MenuType.edit,
  );
  static MenuItem get deleteIcon => MenuItem(
    text: "delete_device_menu".tr,
    icon: Icons.delete_rounded,
    type: MenuType.delete,
  );
  static MenuItem get editPasswordIcon => MenuItem(
    text: "edit_password_menu".tr,
    icon: Icons.key,
    type: MenuType.editPassword,
  );

  static List<MenuItem> get items => [
    modulLogs,
    editIcon,
    editPasswordIcon,
    deleteIcon,
  ];

  static Widget buildItem(MenuItem item) {
    return item.type == MenuType.delete
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

    switch (item.type) {
      case MenuType.edit:
        controller.selectedImage.value = null;
        CustomDialog.show(
          widthChild: double.infinity,
          dialogMargin: 20,
          context: context,
          title: Row(
            spacing: 10.w,
            children: [
              Icon(LucideIcons.squarePen, color: AppTheme.primaryColor),
              Text("edit_device_dialog_title".tr, style: AppTheme.h4),
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
                    title: "device_name_label".tr,
                    validator: controller.validateName,
                    controller: controller.modulNameC,
                    hint: "device_name_hint".tr,
                    borderRadius: 10,
                  ),
                  MyTextField(
                    fieldWidth: double.infinity,
                    title: "device_description_label".tr,
                    controller: controller.modulDescriptionC,
                    hint: "device_description_hint".tr,
                    borderRadius: 10,
                    validator: controller.validateDescription,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("device_image_label".tr, style: AppTheme.h4),
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
                                        (AppConfig.imageUrl + modul.image!),
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
                        title: "button_cancel".tr,
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
                              : Text("button_save".tr),
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
      case MenuType.delete:
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
                Text("delete_device_dialog_title".tr, style: AppTheme.h4),
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
                  "delete_device_dialog_message".tr,
                  textAlign: TextAlign.center,
                  style: AppTheme.textDefault,
                ),
                Row(
                  spacing: 15.r,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyFilledButton(
                      title: "button_cancel".tr,
                      onPressed: () {
                        Get.back();
                      },
                      backgroundColor: AppTheme.surfaceColor,
                      textColor: AppTheme.surfaceDarker,
                    ),
                    MyFilledButton(
                      title: "button_delete".tr,
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
      case MenuType.editPassword:
        controller.isPasswordFormValid.value = false;
        CustomDialog.show(
          dialogMargin: 40,
          context: context,
          title: Row(
            spacing: 10.w,
            children: [
              Icon(Icons.lock_outline, color: AppTheme.primaryColor),
              Text("edit_password_dialog_title".tr, style: AppTheme.h4),
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
                    title: "new_password_label".tr,
                    controller: controller.modulNewPassC,
                    validator: controller.validatePassword,
                    hint: "password_hint".tr,
                    borderRadius: 10,
                  ),
                  MyTextField(
                    title: "confirm_password_label".tr,
                    controller: controller.modulConfirmNewPassC,
                    validator: controller.validateConfirmPassword,
                    hint: "password_hint".tr,
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
                        title: "button_cancel".tr,
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
                              : Text("button_save".tr),
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
      case MenuType.logs:
        Get.back();

        final mainNavController = Get.find<MainNavigationController>();
        mainNavController.modulIdArg = controller.modul.value;
        mainNavController.navigateToHistory();
    }
  }
}
