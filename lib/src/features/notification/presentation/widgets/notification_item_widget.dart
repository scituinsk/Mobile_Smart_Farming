import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/time_parser_helper.dart';
import 'package:pak_tani/src/core/widgets/my_display_chip.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/notification/domain/entities/notification_item.dart';
import 'package:pak_tani/src/features/notification/domain/value_objects/notification_type.dart';
import 'package:pak_tani/src/features/notification/presentation/controllers/notification_screen_controller.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationItem notificationItem;
  const NotificationItemWidget({super.key, required this.notificationItem});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationScreenController>();
    final String createdAt =
        "${TimeParserHelper.formatDateTimeToString(notificationItem.createdAt)}\n${notificationItem.createdAt.day}/${notificationItem.createdAt.month}/${notificationItem.createdAt.year}";
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1.w),
        ),
      ),
      child: ListTile(
        onTap: !notificationItem.readStatus
            ? () => controller.markReadNotification(notificationItem.id)
            : null,
        leading: MyIcon(
          customIcon: notificationItem.notificationType.icon,
          iconSize: 30,
          padding: 10,
        ),
        title: Text(notificationItem.title, style: AppTheme.text),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notificationItem.notificationType == NotificationType.schedule)
              MyDisplayChip(
                backgroundColor: AppTheme.primaryColor,

                child: Text(
                  TimeParserHelper.formatDateTimeToString(
                    notificationItem.createdAt,
                  ),
                  style: AppTheme.textAction.copyWith(color: Colors.white),
                ),
              ),
            SizedBox(height: 5.h),
            Text(
              notificationItem.message,
              style: AppTheme.textSmall.copyWith(
                color: AppTheme.titleSecondary,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 4.r,
          children: [
            Text(
              createdAt,
              textAlign: TextAlign.end,
              style: AppTheme.textSmall.copyWith(color: AppTheme.primaryColor),
            ),
            if (!notificationItem.readStatus)
              Container(
                width: 8.w,
                height: 8.h,
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
}
