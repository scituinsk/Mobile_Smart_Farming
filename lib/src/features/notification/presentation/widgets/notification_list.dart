import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/features/notification/presentation/widgets/notification_item.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  final List<Map<String, dynamic>> notifications = const [
    {
      "message": "Solenoid 1 pada Green House A telah terbuka",
      "time": "08:32",
      "isRead": false,
      "type": NotificationType.solenoid,
    },
    {
      "message": "Water pump pada Green House B telah diaktifkan",
      "time": "07:45",
      "isRead": true,
      "type": NotificationType.waterPump,
    },
    {
      "message": "Suhu Green House A mencapai 35°C",
      "time": "06:20",
      "isRead": false,
      "type": NotificationType.greenHouse,
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
      "type": NotificationType.solenoid,
    },
    {
      "message": "Water pump pada Green House A telah dimatikan",
      "time": "3 hari lalu",
      "isRead": false,
      "type": NotificationType.waterPump,
    },
    {
      "message": "Kelembaban Green House B mencapai 85%",
      "time": "4 hari lalu",
      "isRead": true,
      "type": NotificationType.greenHouse,
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
      "type": NotificationType.solenoid,
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
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 60.h),
        itemCount: notifications.length,
        itemBuilder: (context, index) => Column(
          children: [
            NotificationItem(
              message: notifications[index]["message"],
              time: notifications[index]["time"],
              isRead: notifications[index]["isRead"],
              type: notifications[index]["type"],
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }
}
