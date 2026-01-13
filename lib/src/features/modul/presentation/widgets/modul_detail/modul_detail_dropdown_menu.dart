import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_detail/modul_detail_dropdown_menu_items.dart';

class ModulDetailDropdownMenu extends StatelessWidget {
  const ModulDetailDropdownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        alignment: Alignment.bottomLeft,
        customButton: MyIcon(
          icon: LucideIcons.ellipsisVertical,
          iconColor: AppTheme.primaryColor,
        ),
        items: [
          ...ModulDetailDropdownMenuItems.items.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: ModulDetailDropdownMenuItems.buildItem(item),
            ),
          ),
        ],
        onChanged: (value) {
          ModulDetailDropdownMenuItems.onChanged(context, value!);
        },
        dropdownStyleData: DropdownStyleData(
          width: 180.w,
          padding: EdgeInsets.all(0),
          useSafeArea: true,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.r),
            color: Colors.white,
          ),
          offset: Offset(-120.w, -10.h),
        ),
      ),
    );
  }
}
