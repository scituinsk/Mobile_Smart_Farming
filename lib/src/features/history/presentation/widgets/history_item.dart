import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_display_chip.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';

class HistoryItem extends StatelessWidget {
  final String title;
  final String time;
  final String description;
  final bool isExpandable;
  final String date;
  const HistoryItem({
    super.key,
    required this.title,
    required this.time,
    required this.description,
    this.isExpandable = true,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.titleSecondary.withValues(alpha: 0.3),
            width: 1.2.w,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.r),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: MyIcon(
                icon: LucideIcons.calendarSync,
                backgroundColor: Colors.white,
                iconColor: AppTheme.primaryColor,
                padding: 10,
                iconSize: 26,
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.r,
                children: [
                  Text(title, style: AppTheme.h4),
                  MyDisplayChip(
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      time,
                      style: AppTheme.text.copyWith(color: Colors.white),
                    ),
                  ),
                  Text(description, style: AppTheme.textAction),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                MyIcon(
                  icon: Icons.keyboard_arrow_down_rounded,
                  backgroundColor: Colors.white,
                  iconSize: 24,
                  padding: 2,
                ),
                Text(
                  date,
                  style: AppTheme.text.copyWith(color: AppTheme.primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
