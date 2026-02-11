import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_checkbox.dart';
import 'package:pak_tani/src/core/widgets/my_display_chip.dart';
import 'package:pak_tani/src/features/history/domain/value_objects/history_type.dart';
import 'package:pak_tani/src/features/history/presentation/controllers/history_controller.dart';
import 'package:pak_tani/src/features/history/presentation/widgets/filter_selection_chip.dart';
import 'package:pak_tani/src/features/history/presentation/widgets/filter_time_button_widget.dart';
import 'package:pak_tani/src/features/history/presentation/widgets/history_filter_tile.dart';
import 'package:pak_tani/src/features/history/presentation/widgets/sorting_tile.dart';

///A class for history screen bottom sheet.
class HistorySheet {
  /// Show shorting history bottom sheet
  static Future<void> showSortingSheet(BuildContext context) async {
    final controller = Get.find<HistoryController>();
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Container(
            // color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100.w,
                  height: 8.h,
                  margin: EdgeInsets.only(bottom: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),

                Text('sorting_title'.tr, style: AppTheme.h4),
                SizedBox(height: 20.h),
                Obx(
                  () => RadioGroup(
                    onChanged: controller.sortingHistories,
                    groupValue: controller.isAscending.value,
                    child: Column(
                      children: [
                        SortingTile(isAscending: true),
                        SizedBox(height: 20.h),
                        SortingTile(isAscending: false),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  /// show filter history bottom sheet
  static Future<void> showFilterSheet(BuildContext context) async {
    final controller = Get.find<HistoryController>();

    await showMaterialModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100.w,
                    height: 8.h,
                    margin: EdgeInsets.only(bottom: 15.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  Text("filter_title".tr, style: AppTheme.h4),
                  SizedBox(height: 20.h),
                  Obx(() {
                    final isSelectedModul = controller.isHistoryTypeSelected(
                      HistoryType.modul,
                    );
                    final isSelectedSchedule = controller.isHistoryTypeSelected(
                      HistoryType.schedule,
                    );
                    return Column(
                      spacing: 20.r,
                      children: [
                        HistoryFilterTile(
                          value: isSelectedModul,
                          onChanged: controller.selectModulHistoryType,
                          title: "filter_device_history".tr,
                        ),

                        HistoryFilterTile(
                          value: isSelectedSchedule,
                          onChanged: controller.selectScheduleHistoryType,
                          title: "filter_schedule_history".tr,
                        ),
                      ],
                    );
                  }),

                  SizedBox(height: 20.h),
                  if (controller.isHistoryTypeSelected(HistoryType.schedule) ||
                      controller.isHistoryTypeSelected(HistoryType.modul))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("filter_select_device".tr, style: AppTheme.h5),
                        SizedBox(height: 8.h),
                        Obx(
                          () => Wrap(
                            spacing: 15.r,
                            runSpacing: 15.r,
                            children: controller.moduls.map((modul) {
                              return FilterSelectionChip(
                                title: modul.name,
                                isSelected: controller.isModulSelected(
                                  modul.id,
                                ),
                                onTap: () =>
                                    controller.selectModulFilter(modul),
                              );
                            }).toList(),
                          ),
                        ),
                        Row(
                          children: [
                            Obx(
                              () => MyCheckbox(
                                value: controller.isModulSelectedAll.value,
                                onChanged: controller.selectAllModulFilter,
                              ),
                            ),
                            Text("filter_select_all".tr),
                          ],
                        ),
                        if (controller.isHistoryTypeSelected(
                          HistoryType.schedule,
                        ))
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "filter_select_schedule_group".tr,
                                style: AppTheme.h5,
                              ),
                              SizedBox(height: 8.h),
                              Obx(() {
                                if (controller.selectedModulGroups.isNotEmpty) {
                                  return Wrap(
                                    spacing: 15.r,
                                    runSpacing: 15.r,
                                    children: controller.selectedModulGroups
                                        .map((group) {
                                          return FilterSelectionChip(
                                            title: group["name"],
                                            isSelected: controller
                                                .isScheduleGroupSelected(
                                                  group["id"] as int,
                                                ),
                                            onTap: () => controller
                                                .selectScheduleGroupFilter(
                                                  group["id"],
                                                ),
                                          );
                                        })
                                        .toList(),
                                  );
                                } else {
                                  return MyDisplayChip(
                                    backgroundColor: AppTheme.warningColor
                                        .withValues(alpha: 0.2),
                                    borderRadius: 5,
                                    borderColor: AppTheme.warningColor,
                                    child: Text(
                                      "filter_select_device_warning".tr,
                                    ),
                                  );
                                }
                              }),
                              if (controller.selectedModulGroups.isNotEmpty)
                                Row(
                                  children: [
                                    Obx(
                                      () => MyCheckbox(
                                        value: controller
                                            .isScheduleGroupSelectedAll
                                            .value,
                                        onChanged: controller
                                            .selectAllScheduleGroupFilter,
                                      ),
                                    ),
                                    Text("filter_select_all".tr),
                                  ],
                                ),
                            ],
                          ),
                      ],
                    ),
                  SizedBox(height: 15.h),
                  if (controller.selectedFilterScheduleGroups.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10.r,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("filter_time_range".tr, style: AppTheme.h5),
                            MyDisplayChip(
                              onPressed: controller.clearDatePicker,
                              backgroundColor: AppTheme.primaryColor,
                              child: Text(
                                "filter_clear".tr,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => FilterTimeButtonWidget(
                                onPressed: () async =>
                                    await controller.pickStartDate(context),
                                dateValue: controller.pickedStartDate.value,
                              ),
                            ),
                            Text("filter_until".tr),
                            Obx(
                              () => FilterTimeButtonWidget(
                                onPressed: () async =>
                                    controller.pickEndDate(context),
                                dateValue: controller.pickedEndDate.value,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      spacing: 12.r,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: controller.resetFilter,
                            child: Text("filter_reset".tr),
                          ),
                        ),
                        Expanded(
                          child: FilledButton(
                            onPressed: controller.applyFilter,
                            child: Text("filter_apply".tr),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
