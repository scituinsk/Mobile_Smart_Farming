import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/group_schedule/domain/entities/schedule.dart';
import 'package:pak_tani/src/features/group_schedule/presentation/controllers/group_schedule_ui_controller.dart';
import 'package:pak_tani/src/features/group_schedule/presentation/widgets/schedule_widgets/schedule_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScheduleList extends StatelessWidget {
  ScheduleList({super.key});

  // final List<Map<String, dynamic>> schedules = const [
  //   {"duration": 30, "time": "06:00", "day": "Sen, Rab, Jum"},
  //   {"duration": 45, "time": "08:30", "day": "Sel, Kam, Sab"},
  //   {"duration": 25, "time": "10:15", "day": "Sen, Rab, Jum"},
  //   {"duration": 40, "time": "14:00", "day": "Setiap Hari"},
  //   {"duration": 20, "time": "17:30", "day": "Sel, Kam, Min"},
  //   {"duration": 35, "time": "19:45", "day": "Rab, Jum, Sab"},
  // ];
  final _controller = Get.find<GroupScheduleUiController>();

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
        spacing: 10,
        children: [
          Text("Daftar Penjadwalan", style: AppTheme.h4),
          if (schedules.isNotEmpty)
            Skeletonizer(
              enabled: isLoading,
              child: Column(
                spacing: 20,
                children: schedules.map((schedule) {
                  return ScheduleItem(schedule: schedule);
                }).toList(),
              ),
            ),
          if (schedules.isEmpty && !isLoading)
            SizedBox(
              width: double.infinity,
              child: Text(
                "Tekan + untuk menambahkan jadwal baru",
                style: AppTheme.text.copyWith(color: AppTheme.titleSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(height: 45),
        ],
      );
    });
  }
}
