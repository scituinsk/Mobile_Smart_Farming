import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';

class ModulDetailFeatureItem extends StatelessWidget {
  final String title;
  final MyCustomIcon? myCustomIcon;
  final IconData icon;
  final VoidCallback? onPressed;
  const ModulDetailFeatureItem({
    super.key,
    required this.title,
    this.myCustomIcon,
    this.icon = Icons.settings,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.all(10.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10.r,
          children: [
            myCustomIcon != null
                ? CustomIcon(type: myCustomIcon!, color: Colors.white)
                : Icon(Icons.settings, color: Colors.white, size: 28),
            Expanded(
              child: Text(
                title,
                style: AppTheme.textMedium.copyWith(color: Colors.white),
                softWrap: true,
              ),
            ),
            MyIcon(
              icon: LucideIcons.arrowRight500,
              iconColor: AppTheme.primaryColor,
              backgroundColor: Colors.white,
              padding: 3,
            ),
          ],
        ),
      ),
    );
  }
}
