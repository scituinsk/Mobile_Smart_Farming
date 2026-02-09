import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/schedule/presentation/controllers/schedule_ui_controller.dart';
import 'package:pak_tani/src/features/schedule/presentation/widgets/solenoid_widgets/solenoid_setting_sheet_chose.dart';

class SolenoidSettingSheet {
  static void show(BuildContext context) async {
    final controller = Get.find<ScheduleUiController>();

    controller.prepareSettingSheet();

    await showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 15.h),
                child: Form(
                  key: controller.sequentalFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Handle bar di atas
                      Container(
                        width: 100.w,
                        height: 8.h,
                        margin: EdgeInsets.only(bottom: 20.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      // Custom top bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              LucideIcons.x,
                              color: AppTheme.primaryColor,
                              size: 30,
                            ),
                          ),
                          Text("solenoid_setting_title".tr, style: AppTheme.h3),
                          Obx(
                            () => IconButton(
                              onPressed: controller.isSubmittingSequential.value
                                  ? null
                                  : () async {
                                      await controller
                                          .handleEditGroupSequential();
                                    },
                              icon: controller.isSubmittingSequential.value
                                  ? CircularProgressIndicator()
                                  : Icon(
                                      LucideIcons.check,
                                      color: AppTheme.primaryColor,
                                      size: 30,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Obx(
                        () => Column(
                          spacing: 26.r,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              controller.solenoidCount.value.toString(),
                              style: AppTheme.largeTimeText,
                            ),

                            Column(
                              spacing: 12.r,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "solenoid_setting_choose_label".tr,
                                  style: AppTheme.textMedium,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SolenoidSettingSheetChose(
                                      text: "solenoid_setting_sequential".tr,
                                      value: true,
                                      groupValue: controller
                                          .isSequentialController
                                          .value,
                                      onChanged: (value) =>
                                          controller
                                                  .isSequentialController
                                                  .value =
                                              value ?? false,
                                    ),
                                    SolenoidSettingSheetChose(
                                      text: "solenoid_setting_simultaneous".tr,
                                      value: false,
                                      groupValue: controller
                                          .isSequentialController
                                          .value,
                                      onChanged: (value) =>
                                          controller
                                                  .isSequentialController
                                                  .value =
                                              value ?? false,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (controller.isSequentialController.value)
                              MyTextField(
                                title: "solenoid_setting_count_label".tr,
                                hint: "solenoid_setting_count_hint".tr,
                                controller:
                                    controller.relaySequentialCountController,
                                keyboardType: TextInputType.number,
                                validator: controller.validateSequential,
                                titleStyle: AppTheme.textMedium,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(12.0.r),
                                  child: CustomIcon(
                                    type: MyCustomIcon.solenoid,
                                  ),
                                ),
                              ),
                            SizedBox(height: 18.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
