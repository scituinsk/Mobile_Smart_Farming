import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A stateless widget for a custom display chip.
/// Display a text or widget with a filled background, optionally clickable.
class MyDisplayChip extends StatelessWidget {
  final Color backgroundColor;
  final double paddingVertical;
  final double paddingHorizontal;
  final Widget child;
  final VoidCallback? onPressed;
  final double? borderWidth;
  final Color? borderColor;
  final double borderRadius;

  const MyDisplayChip({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.paddingVertical = 4,
    this.paddingHorizontal = 8,
    this.onPressed,
    this.borderWidth,
    this.borderColor,
    this.borderRadius = 99,
  });

  @override
  Widget build(BuildContext context) {
    return onPressed == null
        ? Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius.r),
              border: BoxBorder.all(
                color: borderColor ?? Colors.white,
                width: borderWidth?.r ?? 0,
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: paddingVertical.h,
              horizontal: paddingHorizontal.w,
            ),
            child: child,
          )
        : InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(borderRadius.r),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(borderRadius.r),
                border: BoxBorder.all(
                  color: borderColor ?? Colors.white,
                  width: borderWidth?.r ?? 0,
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: paddingVertical.h,
                horizontal: paddingHorizontal.w,
              ),
              child: child,
            ),
          );
  }
}
