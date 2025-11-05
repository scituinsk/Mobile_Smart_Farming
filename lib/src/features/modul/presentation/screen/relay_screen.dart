import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/relay_modul/relay_item.dart';

class RelayScreen extends StatelessWidget {
  const RelayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = Get.height;
    final mediaQueryWidth = Get.width;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 25),
            child: MyBackButton(),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          height: mediaQueryHeight,
          width: mediaQueryWidth,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: BoxBorder.all(
                    color: AppTheme.titleSecondary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    RelayItem(
                      customIcon: MyCustomIcon.lightBulb,
                      title: "lampu",
                      description:
                          "sakelar untuk menyalakan lampu ata aasdf fads",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
