import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/features/scheduling/presentation/widgets/add_schedule_sheet.dart';
import 'package:pak_tani/src/features/scheduling/presentation/widgets/schedule_list.dart';

class SchedulingScreen extends StatelessWidget {
  const SchedulingScreen({super.key});

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
            Text("Penjadwalan", style: AppTheme.h3),
            Text(
              "Mengatur penjadwalan sistem irigasi",
              style: AppTheme.textSmall.copyWith(
                color: AppTheme.titleSecondary,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 22, horizontal: 30),
          width: mediaQueryWidth,
          height: mediaQueryHeight,
          child: Column(
            spacing: 30,
            children: [
              SizedBox(
                width: 200,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTheme.text.copyWith(
                      color: AppTheme.titleSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: 'Penyiraman berikutnya akan dimulai dalam ',
                      ),
                      TextSpan(
                        text: '2 jam 59 menit',
                        style: AppTheme.text.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
