import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/icon_widget.dart';
import 'package:pak_tani/src/features/modul_detail/presentation/widgets/modul_detail_dropdown_menu_items.dart';

class ModulDetailDropdownMenu extends StatelessWidget {
  const ModulDetailDropdownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        alignment: Alignment.bottomLeft,
        customButton: IconWidget(
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
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: Colors.white,
          ),
          offset: const Offset(-120, -10),
        ),
      ),
    );
  }
}
