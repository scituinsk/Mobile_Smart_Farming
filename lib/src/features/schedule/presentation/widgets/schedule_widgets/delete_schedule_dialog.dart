import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_dialog.dart';
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
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(LucideIcons.trash2, color: AppTheme.errorColor, size: 38),
            Text("Hapus Schedule ini?", style: AppTheme.h4),
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
              "Schedule ini akan dihapus.",
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
                            margin: EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text("Hapus", style: TextStyle(color: Colors.white)),
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
