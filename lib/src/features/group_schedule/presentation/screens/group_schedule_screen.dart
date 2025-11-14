import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/features/group_schedule/presentation/controllers/group_schedule_ui_controller.dart';
import 'package:pak_tani/src/features/group_schedule/presentation/widgets/group_schedule_information.dart';
import 'package:pak_tani/src/features/group_schedule/presentation/widgets/schedule_widgets/add_schedule_sheet.dart';
import 'package:pak_tani/src/features/group_schedule/presentation/widgets/schedule_widgets/schedule_list.dart';
import 'package:pak_tani/src/features/group_schedule/presentation/widgets/solenoid_widgets/solenoid_emergency_dialog.dart';
import 'package:pak_tani/src/features/group_schedule/presentation/widgets/solenoid_widgets/solenoid_list.dart';

class GroupScheduleScreen extends StatelessWidget {
  const GroupScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = Get.width;
    final mediaQueryHeight = Get.height;

    final controller = Get.find<GroupScheduleUiController>();

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
        actionsPadding: EdgeInsets.only(right: 30),
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
        minimum: EdgeInsets.only(bottom: 12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          width: mediaQueryWidth,
          height: mediaQueryHeight,
          child: ListView(
            children: [
              SizedBox(height: 10),
              GroupScheduleInformation(),
              SizedBox(height: 20),
              SolenoidList(),
              SizedBox(height: 20),
              ScheduleList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddScheduleSheet.show(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(LucideIcons.plus),
      ),
    );
  }
}
