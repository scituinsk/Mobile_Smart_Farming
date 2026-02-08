import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_dialog.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/features/schedule/presentation/controllers/schedule_ui_controller.dart';

class DeleteScheduleDialog {
  static void show(BuildContext context, int id) {
    final controller = Get.find<ScheduleUiController>();

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
            Icon(LucideIcons.trash2, color: AppTheme.errorColor, size: 38.r),
            Text("schedule_delete_title".tr, style: AppTheme.h4),
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
              "schedule_delete_message".tr,
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
                  () => FilledButton(
                    onPressed: () {
                      controller.handleDeleteSchedule(id);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        AppTheme.errorColor,
                      ),
                    ),
                    child: controller.isDeletingSchedule.value
                        ? Container(
                            margin: EdgeInsets.all(8.r),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "button_delete".tr,
                            style: TextStyle(color: Colors.white),
                          ),
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
