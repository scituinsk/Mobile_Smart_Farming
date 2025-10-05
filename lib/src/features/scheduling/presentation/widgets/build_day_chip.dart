import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class BuildDayChip extends StatelessWidget {
  final String day;
  final bool isSelected;

  const BuildDayChip({super.key, required this.day, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        day,
        style: TextStyle(
          color: isSelected ? Colors.white : AppTheme.titleSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
