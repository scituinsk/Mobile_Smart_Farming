import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class WaterpumpTag extends StatelessWidget {
  final bool isActive;
  final String? activeLabel;
  final String? inactiveLabel;

  const WaterpumpTag({
    super.key,
    required this.isActive,
    this.activeLabel,
    this.inactiveLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isActive ? Color(0xff9AD16D) : Color(0xffFF8385),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        isActive ? (activeLabel ?? 'Aktif') : (inactiveLabel ?? 'Non-aktif'),
        style: AppTheme.textAction.copyWith(
          color: isActive ? Color(0xff306B00) : Color(0xffAC3B3D),
        ),
      ),
    );
  }
}
