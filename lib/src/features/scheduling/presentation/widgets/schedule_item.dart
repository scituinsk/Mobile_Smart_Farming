import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_switch.dart';

class ScheduleItem extends StatelessWidget {
  final int duration;
  final String time;
  final String day;
  final bool status;
  const ScheduleItem({
    super.key,
    required this.duration,
    required this.time,
    required this.day,
    this.status = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                "Durasi: $duration menit",
                style: AppTheme.text.copyWith(color: AppTheme.titleSecondary),
              ),

              Text(
                time,
                style: AppTheme.h1Rubik.copyWith(color: AppTheme.primaryColor),
              ),
              Text(
                day,
                style: AppTheme.text.copyWith(color: AppTheme.secondaryColor),
              ),
            ],
          ),
          MySwitch(value: status, onChanged: (value) {}, scale: 1.1),
        ],
      ),
    );
  }
}
