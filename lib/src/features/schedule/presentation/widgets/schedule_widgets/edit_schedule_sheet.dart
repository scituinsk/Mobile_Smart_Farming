import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/time_parser_helper.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/schedule/domain/entities/schedule.dart';
import 'package:pak_tani/src/features/schedule/domain/value_objects/week_day.dart';
import 'package:pak_tani/src/features/schedule/presentation/controllers/schedule_ui_controller.dart';
import 'package:pak_tani/src/features/schedule/presentation/widgets/schedule_widgets/build_day_chip.dart';
import 'package:pak_tani/src/features/schedule/presentation/widgets/schedule_widgets/delete_schedule_dialog.dart';

class EditScheduleSheet {
  static void show(BuildContext context, Schedule schedule) async {
    final controller = Get.find<ScheduleUiController>();

    controller.initEditScheduleSheet(schedule);
    await showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
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
                      onPressed: () =>
                          DeleteScheduleDialog.show(context, schedule.id),
                      icon: Icon(
                        LucideIcons.trash2,
                        color: AppTheme.errorColor,
                        size: 30,
                      ),
                    ),
                    Text("schedule_edit_title".tr, style: AppTheme.h4),
                    Obx(
                      () => IconButton(
                        onPressed: controller.isFormValid.value
                            ? () async => await controller.handleEditSchedule(
                                schedule.id,
                              )
                            : null,
                        icon: controller.isSavingSchedule.value
                            ? CircularProgressIndicator()
                            : Icon(
                                LucideIcons.check,
                                color: controller.isFormValid.value
                                    ? AppTheme.primaryColor
                                    : AppTheme.surfaceActive,
                                size: 30,
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 33.r,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "schedule_time_label".tr,
                              style: AppTheme.textDefault,
                            ),
                            Obx(() {
                              final time = controller.timeController.value;
                              return Text(
                                time != null
                                    ? TimeParserHelper.formatTimeOfDay(time)
                                    : "--:--",
                                style: AppTheme.largeTimeText,
                              );
                            }),
                            FilledButton(
                              onPressed: () async =>
                                  controller.handlePickTime(context),
                              child: Text("schedule_pick_time_button".tr),
                            ),
                          ],
                        ),

                        // Durasi Penyiraman Section
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          padding: EdgeInsets.all(25.r),
                          child: Column(
                            spacing: 21.r,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Form(
                                key: controller.scheduleFormKey,
                                child: MyTextField(
                                  controller:
                                      controller.scheduleDurationController,
                                  focusNode: controller.scheduleDurationFocus,
                                  title: "schedule_duration_label".tr,
                                  hint: "schedule_duration_hint".tr,
                                  prefixIcon: Icon(
                                    LucideIcons.clock,
                                    color: AppTheme.secondaryColor,
                                  ),
                                  keyboardType: TextInputType.number,
                                  fillColor: Colors.white,
                                  gap: 10,
                                  validator: controller.validateDuration,
                                ),
                              ),

                              // Ulangi Penyiraman Section
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 6.r,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "schedule_repeat_label".tr,
                                        style: AppTheme.textMedium,
                                      ),
                                      Row(
                                        spacing: 10.r,
                                        children: [
                                          TextButton(
                                            onPressed: controller.selectAllDays,
                                            child: Text(
                                              "schedule_all_button".tr,
                                              style: TextStyle(
                                                color: AppTheme.primaryColor,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: controller.clearDays,
                                            child: Text(
                                              "schedule_reset_button".tr,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // Hari dalam seminggu
                                  Obx(
                                    () => Wrap(
                                      spacing: 15.r,
                                      runSpacing: 15.r,
                                      children: WeekDay.values.map((day) {
                                        final isSelected = controller
                                            .isDaySelected(day);
                                        return BuildDayChip(
                                          day: day.long,
                                          isSelected: isSelected,
                                          onTap: () =>
                                              controller.toggleDay(day),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((_) => controller.disposeScheduleSheet());
  }
}
