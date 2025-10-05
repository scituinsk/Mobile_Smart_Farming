import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_dialog.dart';
import 'package:pak_tani/src/core/widgets/icon_widget.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/features/solenoid/presentation/widgets/solenoid_list.dart';
import 'package:pak_tani/src/features/solenoid/presentation/widgets/solenoid_setting_sheet.dart';

class SolenoidScreen extends StatelessWidget {
  const SolenoidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = Get.width;
    final mediaQueryHeight = Get.height;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 25),
            child: MyBackButton(),
          ),
        ),
        title: Column(
          children: [
            Text("Solenoid", style: AppTheme.h3),
            Text(
              "Mengatur penjadwalan sistem irigasi",
              style: AppTheme.textSmall.copyWith(
                color: AppTheme.titleSecondary,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actionsPadding: EdgeInsets.only(right: 30),
        actions: [
          IconWidget(
            icon: Icons.settings,
            onPressed: () => SolenoidSettingSheet.show(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 22, horizontal: 30),
          width: mediaQueryWidth,
          height: mediaQueryHeight,
          child: Column(
            spacing: 15,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Daftar Solenoid", style: AppTheme.h4),
                  FilledButton.icon(
                    onPressed: () {
                      Get.toNamed(RouteNamed.schedulingPage);
                    },
                    icon: Icon(LucideIcons.calendarSync),
                    label: Text("Penjadwalan"),
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      minimumSize: WidgetStateProperty.all(Size(0, 32)),
                    ),
                  ),
                ],
              ),
              SolenoidList(),
              SizedBox(
                width: double.infinity, // Make the button stretch horizontally
                child: FilledButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppTheme.errorColor,
                    ),
                  ),
                  onPressed: () {
                    CustomDialog.show(
                      context: context,
                      widthTitle: double.infinity,
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Column(
                          spacing: 8,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_rounded,
                              color: AppTheme.primaryColor,
                              size: 38,
                            ),
                            Text("Peringatan!", style: AppTheme.h4),
                            Text(
                              'Nonaktifkan semua solenoid?',
                              style: AppTheme.textAction,
                            ),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 6,
                        ),
                        child: Column(
                          spacing: 20,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Tindakan ini akan menghentikan semua jadwal dan operasi irigasi.",
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
                                MyFilledButton(
                                  title: "Konfirmasi",
                                  onPressed: () {},
                                  backgroundColor: AppTheme.errorColor,
                                  textColor: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  label: Text("Tombol Darurat"),
                  icon: Icon(Icons.warning),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
