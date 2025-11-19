import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_switch.dart';
import 'package:pak_tani/src/features/group_schedule/domain/entities/schedule.dart';
import 'package:pak_tani/src/features/group_schedule/presentation/widgets/schedule_widgets/edit_schedule_sheet.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScheduleItem extends StatelessWidget {
  final Schedule schedule;
  const ScheduleItem({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    final isSkeleton = Skeletonizer.of(context).enabled;
    return InkWell(
      onTap: () => EditScheduleSheet.show(context),
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
                : MySwitch(
                    value: schedule.isActive,
                    onChanged: (value) {},
                    scale: 1.1,
                  ),
          ],
        ),
      ),
    );
  }
}
