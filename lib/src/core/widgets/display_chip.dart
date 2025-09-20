import 'package:flutter/material.dart';

class DisplayChip extends StatelessWidget {
  final Color backgroundColor;
  final double paddingVertical;
  final double paddingHorizontal;
  final Widget child;

  const DisplayChip({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.paddingVertical = 4,
    this.paddingHorizontal = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(99),
      ),
      padding: EdgeInsets.symmetric(
        vertical: paddingVertical,
        horizontal: paddingHorizontal,
      ),
      child: child,
    );
  }
}
