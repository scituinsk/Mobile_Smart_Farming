import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';

class ShowMenuEditSheet {
  static void show(BuildContext context) async {
    // final controller = Get.find<ModulDetailUiController>();
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          // color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Pilih Menu Edit', style: AppTheme.h4),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(LucideIcons.group, color: Colors.white),
                title: Text(
                  'Edit Group',
                  style: AppTheme.textMedium.copyWith(color: Colors.white),
                ),
                tileColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () async {
                  // Get.back();
                  // await controller.pickAndCropImage(ImageSource.camera);
                },
              ),
              SizedBox(height: 20),
              ListTile(
                leading: CustomIcon(
                  type: MyCustomIcon.solenoid,
                  color: AppTheme.primaryColor,
                ),
                title: Text(
                  'Edit Relay',
                  style: AppTheme.textMedium.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
                tileColor: AppTheme.surfaceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () async {
                  // Get.back();
                  // await controller.pickAndCropImage(ImageSource.gallery);
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
