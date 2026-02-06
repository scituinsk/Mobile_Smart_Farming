import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class MyCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  const MyCheckbox({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      side: BorderSide(
        color: value ? Colors.transparent : AppTheme.surfaceHover,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.r)),
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.white;
        }
        return value ? AppTheme.primaryColor : Colors.transparent;
      }),
      value: value,
      onChanged: onChanged,
    );
  }
}
