import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class SortingTile extends StatelessWidget {
  final bool isAscending;
  final bool groupValue;
  final ValueChanged<bool?>? onChanged;
  const SortingTile({
    super.key,
    required this.isAscending,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onChanged?.call(isAscending),
      leading: Icon(
        isAscending ? LucideIcons.arrowUp : LucideIcons.arrowDown,
        color: AppTheme.primaryColor,
      ),
      title: Text(
        isAscending ? "Terlama/Ascending" : 'Terbaru/Descending',
        style: AppTheme.textMedium.copyWith(color: AppTheme.primaryColor),
      ),

      tileColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      trailing: Radio<bool>(
        value: isAscending,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }
}
