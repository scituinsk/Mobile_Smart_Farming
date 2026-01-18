import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';
import 'package:pak_tani/src/features/relays/presentation/controllers/relay_ui_controller.dart';

class ShowMenuEditSheet {
  static void show(BuildContext context) async {
    final controller = Get.find<RelayUiController>();
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Container(
          // color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Pilih Menu Edit', style: AppTheme.h4),
              SizedBox(height: 20.h),
              Obx(
                () => ListTile(
                  leading: Icon(
                    LucideIcons.group,
                    color: !controller.isEditingGroup.value
                        ? AppTheme.primaryColor
                        : Colors.white,
                  ),
                  title: Text(
                    'Edit Group',
                    style: AppTheme.textMedium.copyWith(
                      color: !controller.isEditingGroup.value
                          ? AppTheme.primaryColor
                          : Colors.white,
                    ),
                  ),
                  tileColor: controller.isEditingGroup.value
                      ? AppTheme.primaryColor
                      : AppTheme.surfaceColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  onTap: () => controller.setEditingGroup(),
                ),
              ),
              SizedBox(height: 20.h),
              Obx(
                () => ListTile(
                  leading: CustomIcon(
                    type: MyCustomIcon.solenoid,
                    color: !controller.isEditingRelay.value
                        ? AppTheme.primaryColor
                        : Colors.white,
                  ),
                  title: Text(
                    'Edit Relay',
                    style: AppTheme.textMedium.copyWith(
                      color: !controller.isEditingRelay.value
                          ? AppTheme.primaryColor
                          : Colors.white,
                    ),
                  ),
                  tileColor: controller.isEditingRelay.value
                      ? AppTheme.primaryColor
                      : AppTheme.surfaceColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  onTap: () => controller.setEditingRelay(),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }
}
