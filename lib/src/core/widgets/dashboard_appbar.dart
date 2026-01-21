import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_list/modul_list_sheets.dart';

class DashboardAppbar extends StatelessWidget {
  const DashboardAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 12.r,
          children: [
            CustomIcon(type: MyCustomIcon.logoPrimary, size: 50),
            Text("PakTani", style: AppTheme.h3),
          ],
        ),
        Row(
          spacing: 12.r,
          children: [
            MyIcon(
              icon: LucideIcons.search,
              iconColor: AppTheme.primaryColor,
              onPressed: () async {
                await ModulListSheets.showSearchField(context);
              },
            ),
            MyIcon(
              icon: Icons.notifications,
              iconColor: AppTheme.primaryColor,
              onPressed: () => Get.toNamed(RouteNames.notificationPage),
            ),
          ],
        ),
      ],
    );
  }
}
