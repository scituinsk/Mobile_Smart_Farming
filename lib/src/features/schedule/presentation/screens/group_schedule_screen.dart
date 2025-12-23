import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/features/schedule/presentation/controllers/schedule_ui_controller.dart';
import 'package:pak_tani/src/features/schedule/presentation/widgets/schedule_information.dart';
import 'package:pak_tani/src/features/schedule/presentation/widgets/schedule_widgets/add_schedule_sheet.dart';
import 'package:pak_tani/src/features/schedule/presentation/widgets/schedule_widgets/schedule_list.dart';
import 'package:pak_tani/src/features/schedule/presentation/widgets/solenoid_widgets/solenoid_emergency_dialog.dart';
import 'package:pak_tani/src/features/schedule/presentation/widgets/solenoid_widgets/solenoid_list.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = Get.width;
    final mediaQueryHeight = Get.height;

    final controller = Get.find<ScheduleUiController>();

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 25.w),
            child: MyBackButton(),
          ),
        ),
        title: Column(
          children: [
            Text(controller.selectedRelayGroup.value!.name, style: AppTheme.h3),
            Text(
              "Atur penjadwalan group",
              style: AppTheme.textSmall.copyWith(
                color: AppTheme.titleSecondary,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actionsPadding: EdgeInsets.only(right: 30.w),
        actions: [
          MyIcon(
            icon: Icons.warning,
            onPressed: () => SolenoidEmergencyDialog.show(context),
            iconColor: Colors.white,
            backgroundColor: AppTheme.errorColor,
          ),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(bottom: 12.h),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 30.w),
          width: mediaQueryWidth,
          height: mediaQueryHeight,
          child: ListView(
            children: [
              SizedBox(height: 10.h),
              GroupScheduleInformation(),
              SizedBox(height: 20.h),
              SolenoidList(),
              SizedBox(height: 20.h),
              ScheduleList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddScheduleSheet.show(context);
        },
        backgroundColor: AppTheme.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Icon(LucideIcons.plus),
      ),
    );
  }
}
