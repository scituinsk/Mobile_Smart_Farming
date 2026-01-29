import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';
import 'package:pak_tani/src/features/notification/domain/entities/notification_item.dart';
import 'package:pak_tani/src/features/notification/presentation/controllers/notification_screen_controller.dart';
import 'package:pak_tani/src/features/notification/presentation/widgets/notification_item_widget.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationScreenController>();
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.h),
                Text('Memuat riwayat notifikasi...'),
              ],
            ),
          );
        }

        if (controller.notificationItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIcon(type: MyCustomIcon.notifEmpty, size: 300),
                Text(
                  controller.isShowUnread.value
                      ? 'Tidak ada notifikasi yang belum dibaca'
                      : "Tidak ada notifikasi",
                  style: AppTheme.text.copyWith(color: AppTheme.ternaryColor),
                ),
                SizedBox(height: 16.h),
                FilledButton.icon(
                  onPressed: () => controller.refreshNotificationItems(),
                  label: Text('Refresh'),
                  icon: Icon(LucideIcons.refreshCcw),
                  iconAlignment: IconAlignment.end,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 60.h),
            itemCount: controller.notificationItems.length,
            itemBuilder: (context, index) {
              final NotificationItem notificationItem =
                  controller.notificationItems[index];
              return Column(
                children: [
                  NotificationItemWidget(notificationItem: notificationItem),
                  SizedBox(height: 5.h),
                ],
              );
            },
          ),
          onRefresh: () => controller.refreshNotificationItems(),
        );
      }),
    );
  }
}
