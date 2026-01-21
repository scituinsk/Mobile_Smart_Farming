/// A stateful widget that displays an expandable button with animaion.
/// The button toggles between expanded and collapsed stetes, rotating an arrow icon on tap.

library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

/// A stateful widget for an expandable button
/// Toggles expandison state on tap, with an animated rotating arrow icon.
class ExpandableButton extends StatefulWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final double width;
  final Widget child;

  /// Callback function called when the expansion state changes.
  /// Recives a boolean indicating if the button is expanded.
  final Function(bool isExpanded)? onExpandChanged;

  const ExpandableButton({
    super.key,
    required this.child,
    this.backgroundColor = AppTheme.primaryColor,
    this.foregroundColor = Colors.white,
    this.borderRadius = 20,
    this.onExpandChanged,
    this.width = 180,
  });

  @override
  State<ExpandableButton> createState() => _ExpandableButtonState();
}

class _ExpandableButtonState extends State<ExpandableButton> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
        widget.onExpandChanged?.call(isExpanded);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        constraints: BoxConstraints(maxWidth: widget.width.w),

        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 2.r,
          children: [
            Flexible(child: widget.child),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: widget.foregroundColor,
                size: 20.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
