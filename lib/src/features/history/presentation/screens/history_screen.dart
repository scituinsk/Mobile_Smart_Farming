import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/history/presentation/widgets/history_list_widget.dart';
import 'package:pak_tani/src/features/history/presentation/widgets/search_history_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: Get.width,
        height: Get.height,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 22.h),
        child: Column(
          children: [
            Column(
              children: [
                Text("history_log_title".tr, style: AppTheme.h3),
                Text("history_log_subtitle".tr, style: AppTheme.textAction),
              ],
            ),
            SizedBox(height: 25.h),
            SearchHistoryWidget(),
            SizedBox(height: 25.h),
            HistoryListWidget(),
          ],
        ),
      ),
    );
  }
}
