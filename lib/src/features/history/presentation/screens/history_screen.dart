import 'package:flutter/material.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 22),
        child: Column(
          children: [
            Column(
              children: [
                Text("Log Riwayat", style: AppTheme.h3),
                Text("Catatan aktivitas sistem", style: AppTheme.textAction),
              ],
            ),
            SizedBox(height: 25),
            SearchHistoryWidget(),
            SizedBox(height: 25),
            HistoryListWidget(),
          ],
        ),
      ),
    );
  }
}
