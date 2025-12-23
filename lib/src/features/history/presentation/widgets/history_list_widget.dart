import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/history/presentation/widgets/history_item.dart';

class HistoryListWidget extends StatelessWidget {
  const HistoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Daftar Riwayat", style: AppTheme.h5),
        HistoryItem(
          title: "Group 1",
          time: "12:00",
          description: "Penjadwalan telah dimulai",
          date: "08/09/2025",
        ),
      ],
    );
  }
}
