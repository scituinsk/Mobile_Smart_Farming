import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/scheduling/presentation/widgets/schedule_item.dart';

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
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 17,
        children: [
          Text("Daftar Penjadwalan", style: AppTheme.h4),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 40),
              itemCount: schedules.length,
              itemBuilder: (context, index) => Column(
                children: [
                  ScheduleItem(
                    duration: schedules[index]["duration"],
                    time: schedules[index]["time"],
                    day: schedules[index]["day"],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
