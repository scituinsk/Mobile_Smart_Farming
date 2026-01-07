import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/features/history/presentation/widgets/history_item.dart';

class HistoryListWidget extends StatelessWidget {
  const HistoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.r,
        children: [
          Text("Daftar Riwayat", style: AppTheme.h5),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 55.h),
              children: [
                HistoryItem(
                  title: "Group 1",
                  time: "12:00",
                  description: "Penjadwalan telah dimulai",
                  date: "08/09/2025",
                  isExpandable: false,
                  customIcon: MyCustomIcon.greenHouse,
                ),
                HistoryItem(
                  title: "Group 1",
                  time: "12:00",
                  description: "Penjadwalan telah dimulai",
                  date: "08/09/2025",
                  modul: "GH 1",
                ),
                HistoryItem(
                  title: "Group 1",
                  time: "12:00",
                  description: "Penjadwalan telah dimulai",
                  date: "08/09/2025",
                  modul: "GH 1",
                ),
                HistoryItem(
                  title: "Group 1",
                  time: "12:00",
                  description: "Penjadwalan telah dimulai",
                  date: "08/09/2025",
                  modul: "GH 1",
                ),
                HistoryItem(
                  title: "Group 1",
                  time: "12:00",
                  description: "Penjadwalan telah dimulai",
                  date: "08/09/2025",
                  modul: "GH 1",
                ),
                HistoryItem(
                  title: "Group 1",
                  time: "12:00",
                  description: "Penjadwalan telah dimulai",
                  date: "08/09/2025",
                  modul: "GH 1",
                ),
                HistoryItem(
                  title: "Group 1",
                  time: "12:00",
                  description: "Penjadwalan telah dimulai",
                  date: "08/09/2025",
                  modul: "GH 1",
                ),

                HistoryItem(
                  title: "Group 1",
                  time: "12:00",
                  description: "Penjadwalan telah dimulai",
                  date: "08/09/2025",
                  modul: "GH 1",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
