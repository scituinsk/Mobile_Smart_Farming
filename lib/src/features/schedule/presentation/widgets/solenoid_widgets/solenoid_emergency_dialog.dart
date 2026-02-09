import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_dialog.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/features/schedule/presentation/controllers/schedule_ui_controller.dart';

class SolenoidEmergencyDialog {
  static void show(BuildContext context) {
    final controller = Get.find<ScheduleUiController>();
    CustomDialog.show(
      context: context,
      dialogMargin: 15,
      widthTitle: double.infinity,
      title: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Column(
          spacing: 8.r,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.warning_rounded, color: AppTheme.errorColor, size: 38.r),
            Text("solenoid_emergency_title".tr, style: AppTheme.h4),
            Text(
              'solenoid_emergency_subtitle'.tr,
              style: AppTheme.textAction,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
        child: Column(
          spacing: 20.r,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "solenoid_emergency_message".tr,
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
                Obx(
                  () => MyFilledButton(
                    onPressed: () async {
                      await controller.handleTurnOffAllRelayInGroup();
                    },
                    backgroundColor: AppTheme.errorColor,
                    textColor: Colors.white,
                    child: controller.isLoadingTurnOff.value
                        ? Container(
                            margin: EdgeInsets.all(8.r),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text("solenoid_emergency_deactivate".tr),
                  ),
                ),
                Obx(
                  () => MyFilledButton(
                    onPressed: () async {
                      await controller.handleTurnOnAllRelayInGroup();
                    },
                    backgroundColor: AppTheme.primaryColor,
                    textColor: Colors.white,
                    child: controller.isLoadingTurnOn.value
                        ? Container(
                            margin: EdgeInsets.all(8.r),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text("solenoid_emergency_activate".tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
