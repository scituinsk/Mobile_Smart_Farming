import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';

class RelayItem extends StatelessWidget {
  final MyCustomIcon customIcon;
  final String title;
  final String description;
  final bool status;
  const RelayItem({
    super.key,
    required this.customIcon,
    required this.title,
    required this.description,
    this.status = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyIcon(
            customIcon: customIcon,
            backgroundColor: AppTheme.primaryColor,
            iconColor: Colors.white,
            iconSize: 30,
            padding: 4,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.h4),
                Text(description, style: AppTheme.textAction, softWrap: true),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: status ? Colors.lightGreenAccent : Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: status ? Colors.lightGreenAccent : Colors.red,
                    blurRadius: 2,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
