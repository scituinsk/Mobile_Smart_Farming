import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/history/presentation/widgets/filter_selection_chip.dart';

class HistorySheet {
  static Future<void> showSortingSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        bool selected = true;
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
              ListTile(
                leading: Icon(
                  LucideIcons.arrowDown,
                  color: AppTheme.primaryColor,
                ),
                title: Text(
                  'Terbaru/Descending',
                  style: AppTheme.textMedium.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),

                tileColor: AppTheme.surfaceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                trailing: Radio<bool>(
                  value: true,
                  groupValue: selected,
                  onChanged: (value) => selected = false,
                ),
              ),
              SizedBox(height: 20.h),
              ListTile(
                leading: Icon(
                  LucideIcons.arrowUp,
                  color: AppTheme.primaryColor,
                ),
                title: Text(
                  'Terlama/Ascending',
                  style: AppTheme.textMedium.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
                tileColor: AppTheme.surfaceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                trailing: Radio<bool>(
                  value: false,
                  groupValue: selected,
                  onChanged: (value) => selected = true,
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showFilterSheet(BuildContext context) async {
    final List<Map<String, dynamic>> moduls = [
      {"title": "gh 1", "status": false},
      {"title": "gh 2", "status": false},
      {"title": "gh 3", "status": false},
      {"title": "gh 4", "status": true},
      {"title": "gh 4", "status": true},
      {"title": "gh 4", "status": true},
      {"title": "gh 4", "status": true},
      {"title": "gh 4", "status": true},
    ];
    final List<Map<String, dynamic>> modulGroup = [
      {"title": "gh 1", "status": true},
      {"title": "gh 2", "status": true},
      {"title": "gh 3", "status": true},
      {"title": "gh 4", "status": true},
    ];

    await showMaterialModalBottomSheet(
      // useSafeArea: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
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
              Text("Filter Berdasarkan", style: AppTheme.h4),
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 8.r,
                children: [
                  Text("Pilih Modul", style: AppTheme.h5),
                  Wrap(
                    spacing: 15.r,
                    runSpacing: 15.r,
                    children: moduls.map((modul) {
                      return FilterSelectionChip(
                        title: modul["title"],
                        isSelected: modul["status"],
                      );
                    }).toList(),
                  ),
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {}),
                      Text("Pilih Semua"),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 8.r,
                children: [
                  Text("Pilih Grup Penjadwalan", style: AppTheme.h5),
                  Wrap(
                    spacing: 15.r,
                    runSpacing: 15.r,
                    children: modulGroup.map((group) {
                      return FilterSelectionChip(
                        title: group["title"],
                        isSelected: group["status"],
                      );
                    }).toList(),
                  ),
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (value) {}),
                      Text("Pilih Semua"),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              ListTile(
                // leading: Icon(
                //   LucideIcons.arrowDown,
                //   color: AppTheme.primaryColor,
                // ),
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
                trailing: Checkbox(value: true, onChanged: (value) {}),
              ),
              SizedBox(height: 20.h),
              ListTile(
                // leading: Icon(
                //   LucideIcons.arrowUp,
                //   color: AppTheme.primaryColor,
                // ),
                title: Text(
                  'Histori Penjadwalan Grub',
                  style: AppTheme.textMedium.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
                tileColor: AppTheme.surfaceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                trailing: Checkbox(value: false, onChanged: (value) {}),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }
}
