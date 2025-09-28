import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/icon_widget.dart';

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
          ...MenuItems.items.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value!);
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

class MenuItem {
  final String text;
  final IconData icon;
  const MenuItem({required this.text, required this.icon});
}

abstract class MenuItems {
  static const editIcon = MenuItem(text: "Edit Modul", icon: Icons.edit);
  static const deleteIcon = MenuItem(
    text: "Delete Modul",
    icon: Icons.delete_rounded,
  );

  static const List<MenuItem> items = [editIcon, deleteIcon];

  static Widget buildItem(MenuItem item) {
    return item == deleteIcon
        ? Row(
            spacing: 15,
            children: [
              IconWidget(
                icon: item.icon,
                backgroundColor: AppTheme.errorColor,
                iconColor: Colors.white,
                iconSize: 16,
              ),
              Text(
                item.text,
                style: AppTheme.text.copyWith(color: AppTheme.errorColor),
              ),
            ],
          )
        : Row(
            spacing: 15,
            children: [
              IconWidget(
                icon: item.icon,
                backgroundColor: AppTheme.surfaceColor,
                iconSize: 16,
              ),
              Text(
                item.text,
                style: AppTheme.text.copyWith(color: AppTheme.textColor),
              ),
            ],
          );
  }

  static void onChanged(BuildContext content, MenuItem item) {
    switch (item) {
      case MenuItems.editIcon:
        //do smth
        break;
      case MenuItems.deleteIcon:
        //do smth
        break;
    }
  }
}
