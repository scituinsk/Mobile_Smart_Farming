import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/schedule/presentation/controllers/schedule_ui_controller.dart';
import 'package:pak_tani/src/features/schedule/presentation/widgets/solenoid_widgets/solenoid_setting_sheet.dart';

/// Widget untuk menampilkan informasi mode penjadwalan dan sequential
class GroupScheduleInformation extends StatelessWidget {
  GroupScheduleInformation({super.key});

  final controller = Get.find<ScheduleUiController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(blurRadius: 6, color: Colors.black12, offset: Offset(0, 3)),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            /// Informasi mode penjadwalan umum
            Obx(() {
              final int sequentialCount = controller.sequentialCount.value;
              final bool isSequential = controller.isSequential.value;

              print("sequential count tampilan: $sequentialCount");
              print("apakah sequential tampilan: $isSequential");

              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 6.r,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      isSequential ? "Mode Sequential" : "Mode Normal",
                      style: AppTheme.h4.copyWith(color: AppTheme.primaryColor),
                    ),
                    Text(
                      isSequential
                          ? sequentialCount.toString()
                          : "Status mode penjadwalan sistem",
                      style: isSequential
                          ? AppTheme.h1Rubik.copyWith(
                              color: AppTheme.primaryColor,
                            )
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
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
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
              );
            }),

            /// Garis pemisah vertikal
            Container(
              width: 1.w,
              color: AppTheme.titleSecondary.withValues(alpha: 0.3),
              margin: EdgeInsets.symmetric(horizontal: 12.w),
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
                  Obx(() {
                    final int relayCount = controller.relayCount.value;

                    return Text(
                      relayCount.toString(),
                      style: AppTheme.h1Rubik.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    );
                  }),
                  Text(
                    "Jumlah relay pada grup ${controller.selectedRelayGroup.value!.name}",
                    style: AppTheme.textAction,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            /// Tombol menuju screen pengaturan mode sequential
          ],
        ),
      ),
    );
  }
}
