import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
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
                Icon(
                  Icons.device_hub_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 24.h),
                Text(
                  'No histories found',
                  style: AppTheme.h4.copyWith(color: Colors.grey[600]),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => controller.refreshNotificationItems(),
                  child: Text('Refresh'),
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
