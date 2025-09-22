import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/icon_widget.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/features/solenoid/presentation/widgets/solenoid_list.dart';

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
        actions: [IconWidget(icon: Icons.settings)],
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
                  onPressed: () {},
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
