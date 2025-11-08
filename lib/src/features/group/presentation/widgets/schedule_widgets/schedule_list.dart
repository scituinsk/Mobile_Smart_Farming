import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/group/presentation/widgets/schedule_widgets/schedule_item.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({super.key});

  final List<Map<String, dynamic>> schedules = const [
    {"duration": 30, "time": "06:00", "day": "Sen, Rab, Jum"},
    {"duration": 45, "time": "08:30", "day": "Sel, Kam, Sab"},
    {"duration": 25, "time": "10:15", "day": "Sen, Rab, Jum"},
    {"duration": 40, "time": "14:00", "day": "Setiap Hari"},
    {"duration": 20, "time": "17:30", "day": "Sel, Kam, Min"},
    {"duration": 35, "time": "19:45", "day": "Rab, Jum, Sab"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text("Daftar Penjadwalan", style: AppTheme.h4),
        if (schedules.isNotEmpty)
          Column(
            spacing: 20,
            children: schedules.map((schedule) {
              return ScheduleItem(
                duration: schedule["duration"],
                time: schedule["time"],
                day: schedule["day"],
              );
            }).toList(),
          ),
        if (schedules.isEmpty)
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
  }
}
