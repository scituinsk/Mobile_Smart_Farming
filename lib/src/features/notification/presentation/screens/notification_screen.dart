import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/core/widgets/my_choice_chip.dart';
import 'package:pak_tani/src/features/notification/presentation/widgets/notification_list.dart';
import 'package:pak_tani/src/features/notification/presentation/widgets/notification_search.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = Get.width;
    final mediaQueryHeight = Get.height;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        title: Text("Notifikasi", style: AppTheme.h3),
        centerTitle: true,
        leading: Center(child: MyBackButton()),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
          height: mediaQueryHeight,
          width: mediaQueryWidth,
          child: Column(
            spacing: 12,
            children: [
              SearchWidget(),
              Row(
                spacing: 10,
                children: [
                  MyChoiceChip(selected: true, title: "Semua"),
                  MyChoiceChip(selected: false, title: "Belum Dibaca"),
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Tandai semua dibaca",
                        style: AppTheme.textSmall.copyWith(
                          color: Color(0xff0055A5),
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text("Semua Notifikasi", style: AppTheme.h5),
                    NotificationList(),
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
