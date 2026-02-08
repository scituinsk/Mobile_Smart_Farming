import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/schedule/domain/entities/schedule.dart';
import 'package:pak_tani/src/features/schedule/presentation/controllers/schedule_ui_controller.dart';
import 'package:pak_tani/src/features/schedule/presentation/widgets/schedule_widgets/schedule_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScheduleList extends StatelessWidget {
  ScheduleList({super.key});

  final _controller = Get.find<ScheduleUiController>();

  static final _mockSchedules = List.generate(
    2,
    (index) => Schedule(
      id: index,
      groupId: 0,
      duration: 30,
      time: const TimeOfDay(hour: 8, minute: 0),
      isActive: true,
      repeatMonday: true,
      repeatTuesday: false,
      repeatWednesday: true,
      repeatThursday: false,
      repeatFriday: true,
      repeatSaturday: false,
      repeatSunday: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isLoading = _controller.isFetchingSchedule.value;
      final List<Schedule> schedules = isLoading
          ? _mockSchedules
          : _controller.schedules;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.r,
        children: [
          Text("schedule_list_title".tr, style: AppTheme.h4),
          if (schedules.isNotEmpty)
            Skeletonizer(
              enabled: isLoading,
              child: Column(
                spacing: 20.r,
                children: schedules.map((schedule) {
                  return ScheduleItem(schedule: schedule);
                }).toList(),
              ),
            ),
          if (schedules.isEmpty && !isLoading)
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.h),
              width: double.infinity,
              child: Text(
                "schedule_list_empty".tr,
                style: AppTheme.text.copyWith(color: AppTheme.titleSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(height: 45.h),
        ],
      );
    });
  }
}
