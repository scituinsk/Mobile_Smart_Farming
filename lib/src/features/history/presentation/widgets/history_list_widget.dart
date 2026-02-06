import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/history/domain/entities/history.dart';
import 'package:pak_tani/src/features/history/presentation/controllers/history_controller.dart';
import 'package:pak_tani/src/features/history/presentation/widgets/history_item.dart';

class HistoryListWidget extends StatelessWidget {
  const HistoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.r,
        children: [
          Text("Daftar Riwayat", style: AppTheme.h5),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16.h),
                      Text('Memuat riwayat...'),
                    ],
                  ),
                );
              }

              if (controller.histories.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/image/history_empty.png",
                        width: 200.w,
                        height: 200.h,
                      ),
                      Text(
                        'Riwayat tidak ditemukan atau belum ada',
                        style: AppTheme.text.copyWith(
                          color: AppTheme.ternaryColor,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FilledButton.icon(
                        onPressed: () => controller.refreshHistoryList(),
                        label: Text('Refresh'),
                        icon: Icon(LucideIcons.refreshCcw),
                        iconAlignment: IconAlignment.end,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.refreshHistoryList(),
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 55.h),
                  itemCount: controller.histories.length,
                  itemBuilder: (context, index) {
                    final History history = controller.histories[index];

                    return HistoryItem(history: history);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
