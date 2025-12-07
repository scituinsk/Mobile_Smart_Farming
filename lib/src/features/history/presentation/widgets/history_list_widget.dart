import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class HistoryListWidget extends StatelessWidget {
  const HistoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text("Daftar Riwayat", style: AppTheme.h5)],
    );
  }
}
