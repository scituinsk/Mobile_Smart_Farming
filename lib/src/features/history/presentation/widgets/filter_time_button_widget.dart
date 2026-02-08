import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_display_chip.dart';

/// A widget that displays a filter button for selecting a date.
/// It shows the selected date in DD/MM/YYYY format or "Pilih tanggal" if no date is selected.
/// Tapping the button triggers the [onPressed] callback.
class FilterTimeButtonWidget extends StatelessWidget {
  /// The selected date to display. If null, shows "Pilih tanggal".
  final DateTime? dateValue;

  /// The callback function when the button is pressed.
  final VoidCallback onPressed;

  /// Creates a [FilterTimeButtonWidget].
  const FilterTimeButtonWidget({
    super.key,
    this.dateValue,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    String? dateString;
    if (dateValue != null) {
      dateString = "${dateValue!.day}/${dateValue!.month}/${dateValue!.year}";
    }

    return MyDisplayChip(
      onPressed: onPressed,
      borderColor: AppTheme.surfaceHover,
      backgroundColor: AppTheme.surfaceColor,
      borderRadius: 5,
      child: Row(
        spacing: 4.w,
        children: [
          dateValue != null ? Text(dateString!) : Text("filter_select_date".tr),
          Icon(Icons.calendar_month_rounded, color: AppTheme.primaryColor),
        ],
      ),
    );
  }
}
