import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/features/group/presentation/widgets/group_information.dart';
import 'package:pak_tani/src/features/group/presentation/widgets/schedule_widgets/add_schedule_sheet.dart';
import 'package:pak_tani/src/features/group/presentation/widgets/schedule_widgets/schedule_list.dart';
import 'package:pak_tani/src/features/group/presentation/widgets/solenoid_widgets/solenoid_emergency_dialog.dart';
import 'package:pak_tani/src/features/group/presentation/widgets/solenoid_widgets/solenoid_list.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

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
              GroupInformation(
                isSequentialMode: false,
                sequentialCount: 2,
                relayCount: 8,
              ),
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
