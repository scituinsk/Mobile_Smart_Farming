import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/time_of_day_parse_helper.dart';
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar di atas
              Container(
                width: 100,
                height: 8,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
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
                  Text("Ubah Penjadwalan", style: AppTheme.h4),
                  Obx(
                    () => IconButton(
                      onPressed: () =>
                          controller.handleEditSchedule(schedule.id),
                      icon: controller.isSavingSchedule.value
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
              SizedBox(height: 5),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 33,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Waktu Penjadwalan",
                            style: AppTheme.textDefault,
                          ),
                          Obx(() {
                            final time = controller.timeController.value;
                            return Text(
                              time != null
                                  ? TimeOfDayParseHelper.formatTimeOfDay(time)
                                  : "--:--",
                              style: AppTheme.largeTimeText,
                            );
                          }),
                          FilledButton(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime:
                                    controller.timeController.value ??
                                    TimeOfDay.now(),
                              );
                              if (time != null) {
                                controller.timeController.value = time;
                              }
                            },
                            child: Text("Pilih Waktu"),
                          ),
                        ],
                      ),

                      // Durasi Penyiraman Section
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.all(25),
                        child: Column(
                          spacing: 21,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyTextField(
                              controller: controller.scheduleDurationController,
                              focusNode: controller.scheduleDurationFocus,
                              title: "Durasi Penyiraman",
                              hint: "Masukkan durasi (menit)",
                              prefixIcon: Icon(
                                LucideIcons.clock,
                                color: AppTheme.secondaryColor,
                              ),
                              keyboardType: TextInputType.number,
                              fillColor: Colors.white,
                              gap: 10,
                            ),

                            // Ulangi Penyiraman Section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 6,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Ulangi penyiraman",
                                      style: AppTheme.textMedium,
                                    ),
                                    Row(
                                      spacing: 10,
                                      children: [
                                        TextButton(
                                          onPressed: controller.selectAllDays,
                                          child: Text(
                                            "Semua",
                                            style: TextStyle(
                                              color: AppTheme.primaryColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: controller.clearDays,
                                          child: Text(
                                            "Reset",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
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
                                    spacing: 15,
                                    runSpacing: 15,
                                    children: WeekDay.values.map((day) {
                                      final isSelected = controller
                                          .isDaySelected(day);
                                      return BuildDayChip(
                                        day: day.long,
                                        isSelected: isSelected,
                                        onTap: () => controller.toggleDay(day),
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
    ).then((_) => controller.disposeScheduleSheet());
  }
}
