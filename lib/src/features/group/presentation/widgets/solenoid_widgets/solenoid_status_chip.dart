import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class SolenoidStatusChip extends StatelessWidget {
  final bool status;
  const SolenoidStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return status
        ? Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.lightGreenAccent, width: 1),
            ),
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
            child: Text(
              "Aktif",
              style: AppTheme.textSmall.copyWith(color: Colors.green),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red, width: 1),
            ),
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
            child: Text(
              "Tidak Aktif",
              style: AppTheme.textSmall.copyWith(color: Colors.red),
            ),
          );
  }
}
