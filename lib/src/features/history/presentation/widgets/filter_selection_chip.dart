import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class FilterSelectionChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const FilterSelectionChip({
    super.key,
    required this.title,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.titleSecondary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
