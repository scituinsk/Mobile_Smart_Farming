import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_display_chip.dart';
import 'package:pak_tani/src/features/history/domain/value_objects/history_type.dart';
import 'package:pak_tani/src/features/history/presentation/controllers/history_controller.dart';
import 'package:pak_tani/src/features/history/presentation/widgets/filter_selection_chip.dart';
import 'package:pak_tani/src/features/history/presentation/widgets/filter_time_button_widget.dart';
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
        return Container(
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

              Text('Urutkan Berdasarkan', style: AppTheme.h4),
              SizedBox(height: 20.h),
              Obx(
                () => SortingTile(
                  isAscending: true,
                  groupValue: controller.isAscending.value,
                  onChanged: controller.sortingHistories,
                ),
              ),
              SizedBox(height: 20.h),
              Obx(
                () => SortingTile(
                  isAscending: false,
                  groupValue: controller.isAscending.value,
                  onChanged: controller.sortingHistories,
                ),
              ),
              SizedBox(height: 10.h),
            ],
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
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
                Text("Filter Berdasarkan", style: AppTheme.h4),
                SizedBox(height: 20.h),
                Column(
                  spacing: 20.r,
                  children: [
                    ListTile(
                      title: Text(
                        'Histori Perangkat',
                        style: AppTheme.textMedium.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),

                      tileColor: AppTheme.surfaceColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      trailing: Obx(
                        () => Checkbox(
                          value: controller.isHistoryTypeSelected(
                            HistoryType.modul,
                          ),
                          onChanged: controller.selectModulHistoryType,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Histori Penjadwalan Grup',
                        style: AppTheme.textMedium.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      tileColor: AppTheme.surfaceColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      trailing: Obx(
                        () => Checkbox(
                          value: controller.isHistoryTypeSelected(
                            HistoryType.schedule,
                          ),
                          onChanged: controller.selectScheduleHistoryType,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                if (controller.isHistoryTypeSelected(HistoryType.schedule) ||
                    controller.isHistoryTypeSelected(HistoryType.modul))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Pilih Modul", style: AppTheme.h5),
                      SizedBox(height: 8.h),
                      Obx(
                        () => Wrap(
                          spacing: 15.r,
                          runSpacing: 15.r,
                          children: controller.moduls.map((modul) {
                            return FilterSelectionChip(
                              title: modul.name,
                              isSelected: controller.isModulSelected(modul.id),
                              onTap: () => controller.selectModulFilter(modul),
                            );
                          }).toList(),
                        ),
                      ),
                      Row(
                        children: [
                          Obx(
                            () => Checkbox(
                              value: controller.isModulSelectedAll.value,
                              onChanged: controller.selectAllModulFilter,
                            ),
                          ),
                          Text("Pilih Semua"),
                        ],
                      ),
                      if (controller.isHistoryTypeSelected(
                        HistoryType.schedule,
                      ))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pilih Grup Penjadwalan", style: AppTheme.h5),
                            SizedBox(height: 8.h),
                            Obx(() {
                              if (controller.selectedModulGroups.isNotEmpty) {
                                return Wrap(
                                  spacing: 15.r,
                                  runSpacing: 15.r,
                                  children: controller.selectedModulGroups.map((
                                    group,
                                  ) {
                                    return FilterSelectionChip(
                                      title: group["name"],
                                      isSelected: controller
                                          .isScheduleGroupSelected(
                                            group["id"] as int,
                                          ),
                                      onTap: () =>
                                          controller.selectScheduleGroupFilter(
                                            group["id"],
                                          ),
                                    );
                                  }).toList(),
                                );
                              } else {
                                return MyDisplayChip(
                                  backgroundColor: AppTheme.errorColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: 5,
                                  borderColor: AppTheme.errorColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  child: Text(
                                    "Pilih Modul untuk memilih group penjadwalan!",
                                  ),
                                );
                              }
                            }),
                            if (controller.selectedModulGroups.isNotEmpty)
                              Row(
                                children: [
                                  Obx(
                                    () => Checkbox(
                                      value: controller
                                          .isScheduleGroupSelectedAll
                                          .value,
                                      onChanged: controller
                                          .selectAllScheduleGroupFilter,
                                    ),
                                  ),
                                  Text("Pilih Semua"),
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
                          Text("Rentang Waktu", style: AppTheme.h5),
                          MyDisplayChip(
                            onPressed: controller.clearDatePicker,
                            backgroundColor: AppTheme.primaryColor,
                            child: Text(
                              "Clear",
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
                          Text("sampai"),
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
                          child: Text("Reset"),
                        ),
                      ),
                      Expanded(
                        child: FilledButton(
                          onPressed: controller.applyFilter,
                          child: Text("Apply"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
