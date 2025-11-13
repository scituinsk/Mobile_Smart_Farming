import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/group_schedule/presentation/widgets/solenoid_widgets/solenoid_setting_sheet.dart';

/// Widget untuk menampilkan informasi mode penjadwalan dan sequential
class GroupScheduleInformation extends StatelessWidget {
  final bool isSequentialMode;
  final int sequentialCount;
  final int relayCount;

  const GroupScheduleInformation({
    super.key,
    required this.isSequentialMode,
    required this.sequentialCount,
    required this.relayCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(blurRadius: 6, color: Colors.black12, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Informasi mode penjadwalan umum
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 6,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isSequentialMode ? "Mode Sequential" : "Mode Normal",
                  style: AppTheme.h4.copyWith(color: AppTheme.primaryColor),
                ),
                Text(
                  isSequentialMode
                      ? sequentialCount.toString()
                      : "Status mode penjadwalan sistem",
                  style: isSequentialMode
                      ? AppTheme.h1Rubik.copyWith(color: AppTheme.primaryColor)
                      : AppTheme.textAction,
                  textAlign: TextAlign.center,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      SolenoidSettingSheet.show(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                    label: const Text(
                      "Atur Mode",
                      style: TextStyle(color: Colors.white),
                    ),
                    iconAlignment: IconAlignment.end,
                    icon: MyIcon(
                      backgroundColor: Colors.white,
                      iconColor: AppTheme.primaryColor,
                      icon: LucideIcons.arrowRight,
                      padding: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Garis pemisah vertikal
          Container(
            width: 1,
            height: 140,
            color: AppTheme.titleSecondary.withValues(alpha: 0.3),
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),

          /// Informasi tentang jumlah grup sequential
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Jumlah Relay",
                  style: AppTheme.h4,
                  textAlign: TextAlign.center,
                ),
                Text(
                  relayCount.toString(),
                  style: AppTheme.h1Rubik.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
                Text(
                  "Total jumlah relay",
                  style: AppTheme.textAction,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          /// Tombol menuju screen pengaturan mode sequential
        ],
      ),
    );
  }
}
