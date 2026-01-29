import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_checkbox.dart';

class HistoryFilterTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String title;
  const HistoryFilterTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: AppTheme.textMedium.copyWith(color: AppTheme.primaryColor),
      ),
      tileColor: value ? AppTheme.primaryLightHover : AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: value ? AppTheme.primaryColor : AppTheme.surfaceHover,
        ),
      ),
      trailing: MyCheckbox(value: value, onChanged: onChanged),
    );
  }
}
