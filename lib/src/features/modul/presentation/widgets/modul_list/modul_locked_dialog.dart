import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_dialog.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_controller.dart';

class ModulLockedDialog {
  static show(BuildContext context, String serialId) {
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
            Text("Peringatan!", style: AppTheme.h4),
            Text(
              'Password telah diubah!',
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
              "Silahkan ubah password terlebih dahulu untuk dapat mengakses modul atau hapus modul dari akun ini.",
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
                        : Text("Hapus Modul"),
                  ),
                ),

                MyFilledButton(
                  onPressed: () {
                    Get.back();
                    Get.toNamed(RouteNames.addModulPage, arguments: serialId);
                  },
                  backgroundColor: AppTheme.primaryColor,
                  textColor: Colors.white,
                  child: Text("Tambahkan Ulang", textAlign: TextAlign.center),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
