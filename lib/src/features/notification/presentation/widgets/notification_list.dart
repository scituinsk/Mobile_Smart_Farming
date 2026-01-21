import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/notification/domain/entities/notification_item.dart';
import 'package:pak_tani/src/features/notification/domain/value_objects/notification_type.dart';
import 'package:pak_tani/src/features/notification/presentation/controllers/notification_screen_controller.dart';
import 'package:pak_tani/src/features/notification/presentation/widgets/notification_item_widget.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  final List<Map<String, dynamic>> notifications = const [
    {
      "message": "Solenoid 1 pada Green House A telah terbuka",
      "time": "08:32",
      "isRead": false,
      "type": NotificationType.schedule,
    },
    {
      "message": "Water pump pada Green House B telah diaktifkan",
      "time": "07:45",
      "isRead": true,
      "type": NotificationType.system,
    },
    {
      "message": "Suhu Green House A mencapai 35°C",
      "time": "06:20",
      "isRead": false,
      "type": NotificationType.modul,
    },
    {
      "message": "Battery level mencapai 100%",
      "time": "05:15",
      "isRead": true,
      "type": NotificationType.batteryMax,
    },
    {
      "message": "Battery level rendah (15%)",
      "time": "Kemarin",
      "isRead": false,
      "type": NotificationType.batteryLow,
    },
    {
      "message": "Solenoid 2 pada Green House C telah ditutup",
      "time": "2 hari lalu",
      "isRead": true,
      "type": NotificationType.schedule,
    },
    {
      "message": "Water pump pada Green House A telah dimatikan",
      "time": "3 hari lalu",
      "isRead": false,
      "type": NotificationType.system,
    },
    {
      "message": "Kelembaban Green House B mencapai 85%",
      "time": "4 hari lalu",
      "isRead": true,
      "type": NotificationType.modul,
    },
    {
      "message": "Battery level mencapai 95%",
      "time": "5 hari lalu",
      "isRead": false,
      "type": NotificationType.batteryMax,
    },
    {
      "message": "Solenoid 3 pada Green House A telah terbuka",
      "time": "1 minggu lalu",
      "isRead": true,
      "type": NotificationType.schedule,
    },
    {
      "message": "Battery level sangat rendah (5%)",
      "time": "1 minggu lalu",
      "isRead": false,
      "type": NotificationType.batteryLow,
    },
  ];

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
      //  ListView.builder(
      //   padding: EdgeInsets.only(bottom: 60.h),
      //   itemCount: controller.notificationItems.length,
      //   itemBuilder: (context, index) => Column(
      //     children: [
      //       NotificationItemWidget(
      //         notificationItem: controller.notificationItems[index],
      //       ),
      //       SizedBox(height: 5.h),
      //     ],
      //   ),
      // ),
    );
  }
}
