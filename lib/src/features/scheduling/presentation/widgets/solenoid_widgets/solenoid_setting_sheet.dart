import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';
import 'package:pak_tani/src/features/scheduling/presentation/widgets/solenoid_widgets/solenoid_setting_sheet_chose.dart';

class SolenoidSettingSheet {
  static void show(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
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
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        LucideIcons.x,
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                    ),
                    Text("Total Selenoid Aktif", style: AppTheme.h4),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        LucideIcons.check,
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  spacing: 26,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("6", style: AppTheme.largeTimeText),

                    Column(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pilih Penjadwalan", style: AppTheme.textMedium),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SolenoidSettingSheetChose(
                              text: "Bergantian",
                              value: 'bergantian',
                              groupValue: 'bergantian',
                            ),
                            SolenoidSettingSheetChose(
                              text: "Bersamaan",
                              value: 'bersamaan',
                            ),
                          ],
                        ),
                      ],
                    ),
                    MyTextField(
                      title: "Atur Jumlah Solenoid",
                      hint: "Masukkan durasi",
                      titleStyle: AppTheme.textMedium,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CustomIcon(type: MyCustomIcon.solenoid),
                      ),
                    ),
                    SizedBox(height: 18),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
