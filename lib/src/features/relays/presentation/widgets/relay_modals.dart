import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_dialog.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/relays/domain/models/group_relay.dart';
import 'package:pak_tani/src/features/relays/domain/models/relay.dart';
import 'package:pak_tani/src/features/relays/presentation/controllers/relay_ui_controller.dart';

class RelayModals {
  static void showAddModal(BuildContext context) {
    RelayUiController controller = Get.find<RelayUiController>();

    CustomDialog.show(
      // widthTitle: 240,
      context: context,
      dialogMargin: 40,
      title: Text("relay_add_group_title".tr, style: AppTheme.h4),
      child: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 10.r,
            children: [
              MyTextField(
                // fieldWidth: 240,
                title: "relay_group_name_label".tr,
                controller: controller.groupName,
                validator: controller.validateGroupName,
                hint: "relay_group_name_hint".tr,
                borderRadius: 10,
              ),
              Row(
                spacing: 10.r,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyFilledButton(
                    onPressed: () {
                      Get.back();
                    },
                    backgroundColor: AppTheme.surfaceColor,
                    title: "button_cancel".tr,
                    textColor: AppTheme.primaryColor,
                  ),
                  Obx(() {
                    final loading = controller.isLoading.value;
                    return FilledButton(
                      onPressed: !loading
                          ? () async => await controller.handleAddRelayGroup()
                          : null,
                      child: loading
                          ? SizedBox(
                              height: 25.h,
                              width: 25.w,
                              child: CircularProgressIndicator(),
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
    ).then((_) => controller.disposeRelayGroupDialog());
  }

  static void showEditGroupModal(
    BuildContext context,
    RelayGroup relayGroup,
  ) async {
    RelayUiController controller = Get.find<RelayUiController>();

    controller.initEditGroupDialog(relayGroup);
    await CustomDialog.show(
      // widthTitle: 240,
      context: context,
      dialogMargin: 40,
      title: Text("relay_edit_group_title".tr, style: AppTheme.h4),
      child: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 10.r,
            children: [
              MyTextField(
                // fieldWidth: 240,
                title: "relay_group_name_label".tr,
                controller: controller.groupName,
                validator: controller.validateGroupName,
                hint: "relay_group_name_hint".tr,
                borderRadius: 10,
              ),
              Row(
                spacing: 10.r,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyFilledButton(
                    onPressed: () {
                      Get.back();
                    },
                    backgroundColor: AppTheme.surfaceColor,
                    title: "button_cancel".tr,
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
                          ? SizedBox(
                              height: 25.h,
                              width: 25.w,
                              child: CircularProgressIndicator(),
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
    controller.disposeRelayGroupDialog();
  }

  static void showEditRelayModal(BuildContext context, Relay relay) async {
    RelayUiController controller = Get.find<RelayUiController>();
    controller.initEditRelayDialog(relay.name, relay.descriptions);
    await CustomDialog.show(
      // widthTitle: 240,
      dialogMargin: 40,
      context: context,
      title: Text("relay_edit_relay_title".tr, style: AppTheme.h4),
      child: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 10.r,
            children: [
              MyTextField(
                // fieldWidth: 240,
                title: "relay_name_label".tr,
                controller: controller.relayNameC,
                validator: controller.validateRelayName,
                hint: "relay_name_hint".tr,
                borderRadius: 10,
                focusNode: controller.relayNameFocus,
              ),
              MyTextField(
                // fieldWidth: 240,
                title: "relay_description_label".tr,
                controller: controller.relayDescC,
                hint: "relay_description_hint".tr,
                borderRadius: 10,
                validator: controller.validateDescription,
                focusNode: controller.relayDescFocus,
              ),
              Row(
                spacing: 10.r,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyFilledButton(
                    onPressed: () {
                      Get.back();
                    },
                    backgroundColor: AppTheme.surfaceColor,
                    title: "button_cancel".tr,
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
                          ? SizedBox(
                              height: 25.h,
                              width: 25.w,
                              child: CircularProgressIndicator(),
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
    ).then((_) => controller.disposeEditRelayDialog());
  }

  static void showDeleteGroupModal(BuildContext context, int id) {
    final controller = Get.find<RelayUiController>();

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
              Icons.delete_outline_rounded,
              color: AppTheme.errorColor,
              size: 38,
            ),
            Text("relay_delete_group_title".tr, style: AppTheme.h4),
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
              "relay_delete_group_message".tr,
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
                            padding: EdgeInsets.all(5.r),
                          )
                        : Text("button_delete".tr),
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
