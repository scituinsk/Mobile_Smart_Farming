import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';

enum NotificationType {
  solenoid,
  greenHouse,
  waterPump,
  batteryMax,
  batteryLow,
}

class NotificationItem extends StatelessWidget {
  final NotificationType type;
  final String message;
  final String time;
  final bool isRead;
  const NotificationItem({
    super.key,
    this.type = NotificationType.solenoid,
    required this.message,
    required this.time,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: ListTile(
        leading: MyIcon(customIcon: _leadingIcon(), iconSize: 32, padding: 5),
        title: Text(_title(), style: AppTheme.text),
        subtitle: Text(
          message,
          style: AppTheme.textSmall.copyWith(color: AppTheme.titleSecondary),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 4,
          children: [
            Text(
              time,
              style: AppTheme.textSmall.copyWith(color: AppTheme.primaryColor),
            ),
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _title() {
    switch (type) {
      case NotificationType.solenoid:
        return "Solenoid";
      case NotificationType.greenHouse:
        return "Green House";
      case NotificationType.waterPump:
        return "Water Pump";
      case NotificationType.batteryMax:
        return "Baterai";
      case NotificationType.batteryLow:
        return "Baterai";
    }
  }

  MyCustomIcon _leadingIcon() {
    switch (type) {
      case NotificationType.solenoid:
        return MyCustomIcon.solenoid;
      case NotificationType.greenHouse:
        return MyCustomIcon.greenHouse;
      case NotificationType.waterPump:
        return MyCustomIcon.waterPump;
      case NotificationType.batteryMax:
        return MyCustomIcon.batteryMax;
      case NotificationType.batteryLow:
        return MyCustomIcon.batteryLow;
    }
  }
}
