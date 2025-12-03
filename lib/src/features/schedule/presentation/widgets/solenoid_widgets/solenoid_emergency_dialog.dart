import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_dialog.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/features/schedule/presentation/controllers/schedule_ui_controller.dart';

class SolenoidEmergencyDialog {
  static show(BuildContext context) {
    final controller = Get.find<ScheduleUiController>();
    CustomDialog.show(
      context: context,
      dialogMargin: 15,
      widthTitle: double.infinity,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.warning_rounded, color: AppTheme.errorColor, size: 38),
            Text("Peringatan!", style: AppTheme.h4),
            Text(
              'Fitur ini digunakan untuk keadaan darurat atau untuk percobaan/testing!',
              style: AppTheme.textAction,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Pilih aktifkan atau non-aktifkan semua solenoid dalam group ini.",
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
                Obx(
                  () => MyFilledButton(
                    onPressed: () async {
                      await controller.handleTurnOffAllRelayInGroup();
                    },
                    backgroundColor: AppTheme.errorColor,
                    textColor: Colors.white,
                    child: controller.isLoadingTurnOff.value
                        ? Container(
                            margin: EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text("Non-aktif"),
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
                            margin: EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text("Aktif"),
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
