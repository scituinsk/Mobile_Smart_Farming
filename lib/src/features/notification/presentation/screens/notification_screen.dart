import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/core/widgets/my_display_chip.dart';
import 'package:pak_tani/src/features/notification/presentation/controllers/notification_screen_controller.dart';
import 'package:pak_tani/src/features/notification/presentation/widgets/notification_list.dart';

class NotificationScreen extends StatelessWidget {
  /// Notification screen widget.
  ///
  /// Displays the notification list with controls to filter between all and
  /// unread notifications, and a button to mark all notifications as read.
  /// The UI observes `NotificationScreenController` for state changes and
  /// actions (loading, filtering, marking read).
  const NotificationScreen({super.key});

  @override
  /// Builds the notification screen UI and wires controller interactions.
  Widget build(BuildContext context) {
    final mediaQueryWidth = Get.width;
    final mediaQueryHeight = Get.height;
    final controller = Get.find<NotificationScreenController>();

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        title: Text("Notifikasi", style: AppTheme.h3),
        centerTitle: true,
        leading: Center(child: MyBackButton()),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 30.w),
          height: mediaQueryHeight,
          width: mediaQueryWidth,
          child: Column(
            spacing: 12.r,
            children: [
              Row(
                spacing: 10.r,
                children: [
                  Obx(
                    () => MyDisplayChip(
                      backgroundColor: !controller.isShowUnread.value
                          ? AppTheme.secondaryColor
                          : Colors.white,
                      paddingHorizontal: 14,
                      paddingVertical: 7,
                      child: Text(
                        "Semua",
                        style: AppTheme.text.copyWith(
                          color: !controller.isShowUnread.value
                              ? Colors.white
                              : AppTheme.secondaryColor,
                        ),
                      ),
                      onPressed: () {
                        controller.isShowUnread.value = false;
                        controller.filterNotification();
                      },
                    ),
                  ),
                  Obx(
                    () => MyDisplayChip(
                      backgroundColor: controller.isShowUnread.value
                          ? AppTheme.secondaryColor
                          : Colors.white,
                      paddingHorizontal: 14,
                      paddingVertical: 7,
                      child: Text(
                        "Belum Dibaca",
                        style: AppTheme.text.copyWith(
                          color: controller.isShowUnread.value
                              ? Colors.white
                              : AppTheme.secondaryColor,
                        ),
                      ),
                      onPressed: () {
                        controller.isShowUnread.value = true;
                        controller.filterNotification();
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: controller.markReadAllNotification,
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
                  spacing: 6.r,
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
