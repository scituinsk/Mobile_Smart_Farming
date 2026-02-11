import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class SortingTile extends StatelessWidget {
  final bool isAscending;
  // final bool groupValue;
  // final ValueChanged<bool?>? onChanged;
  const SortingTile({
    super.key,
    required this.isAscending,
    // required this.groupValue,
    // required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isAscending ? LucideIcons.arrowUp : LucideIcons.arrowDown,
        color: AppTheme.primaryColor,
      ),
      title: Text(
        isAscending ? "sorting_oldest".tr : "sorting_newest".tr,
        style: AppTheme.textMedium.copyWith(color: AppTheme.primaryColor),
      ),

      tileColor: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      trailing: Radio<bool>(value: isAscending),
    );
  }
}
