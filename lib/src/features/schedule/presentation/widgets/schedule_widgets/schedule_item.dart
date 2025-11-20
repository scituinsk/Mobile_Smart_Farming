import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_switch.dart';
import 'package:pak_tani/src/features/schedule/domain/entities/schedule.dart';
import 'package:pak_tani/src/features/schedule/presentation/controllers/schedule_ui_controller.dart';
import 'package:pak_tani/src/features/schedule/presentation/widgets/schedule_widgets/edit_schedule_sheet.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScheduleItem extends StatelessWidget {
  final Schedule schedule;
  ScheduleItem({super.key, required this.schedule});

  final controller = Get.find<ScheduleUiController>();

  @override
  Widget build(BuildContext context) {
    final isSkeleton = Skeletonizer.of(context).enabled;
    return InkWell(
      onTap: () => EditScheduleSheet.show(context, schedule),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Durasi: ${schedule.duration ?? 0} menit",
                  style: AppTheme.text.copyWith(color: AppTheme.titleSecondary),
                ),

                Text(
                  schedule.getFormattedTime(),
                  style: AppTheme.h1Rubik.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),

                Text(
                  schedule.getActiveDays(),
                  style: AppTheme.text.copyWith(color: AppTheme.secondaryColor),
                ),
              ],
            ),
            isSkeleton
                ? Bone.button(
                    borderRadius: BorderRadius.circular(25),
                    width: 50,
                  )
                : Obx(() {
                    final index = controller.getScheduleIndex(schedule.id);
                    return MySwitch(
                      value: controller.schedules[index].isActive,
                      onChanged: (value) => controller.handleEditStatusSchedule(
                        schedule.id,
                        value,
                      ),
                      scale: 1.1,
                    );
                  }),
          ],
        ),
      ),
    );
  }
}
