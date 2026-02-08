import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_dialog.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_controller.dart';

class ModulLockedDialog {
  static void show(BuildContext context, String serialId) {
    final controller = Get.find<ModulController>();
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
            Text("locked_dialog_warning_title".tr, style: AppTheme.h4),
            Text(
              'locked_dialog_password_changed'.tr,
              style: AppTheme.textAction,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Column(
          spacing: 20.r,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "locked_dialog_message".tr,
              textAlign: TextAlign.center,
              style: AppTheme.textDefault,
            ),
            Row(
              spacing: 10.w,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => MyFilledButton(
                    onPressed: () => controller.deleteLocalModul(serialId),
                    backgroundColor: AppTheme.errorColor,
                    textColor: Colors.white,
                    child: controller.isLoadingModul.value
                        ? Container(
                            margin: EdgeInsets.all(8.r),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text("locked_dialog_delete_button".tr),
                  ),
                ),
                MyFilledButton(
                  onPressed: () {
                    Get.back();
                    Get.toNamed(RouteNames.addModulPage, arguments: serialId);
                  },
                  backgroundColor: AppTheme.primaryColor,
                  textColor: Colors.white,
                  child: Text(
                    "locked_dialog_readd_button".tr,
                    textAlign: TextAlign.center,
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
