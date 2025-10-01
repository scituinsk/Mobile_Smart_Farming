import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_dialog.dart';
import 'package:pak_tani/src/core/widgets/icon_widget.dart';
import 'package:pak_tani/src/core/widgets/my_filled_button.dart';
import 'package:pak_tani/src/core/widgets/my_text_field.dart';

class MenuItem {
  final String text;
  final IconData icon;
  const MenuItem({required this.text, required this.icon});
}

abstract class ModulDetailDropdownMenuItems {
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

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case ModulDetailDropdownMenuItems.editIcon:
        CustomDialog.show(
          widthTitle: 240,
          height: 506,
          context: context,
          title: Text("Edit Modul", style: AppTheme.h4),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 10,
              children: [
                MyTextField(
                  fieldWidth: 240,
                  title: "Nama Modul",
                  hint: "Ex: Green House A",
                  borderRadius: 10,
                ),
                MyTextField(
                  fieldWidth: 240,
                  title: "Deskripsi Modul",
                  hint: "Ex: Green house timur",
                  borderRadius: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Gambar Modul", style: AppTheme.h4),
                    Stack(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 164,
                          width: 240,
                          child: Image.asset('assets/image/default_modul.jpg'),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: IconWidget(
                            icon: Icons.edit,
                            onPressed: () {
                              print("object");
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyFilledButton(
                      onPressed: () {
                        Get.back();
                      },
                      backgroundColor: Colors.white,
                      title: "Batal",
                      textColor: AppTheme.primaryColor,
                    ),
                    MyFilledButton(onPressed: () {}, title: "Simpan"),
                  ],
                ),
              ],
            ),
          ),
        );
        break;
      case ModulDetailDropdownMenuItems.deleteIcon:
        CustomDialog.show(
          context: context,
          widthTitle: double.infinity,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  color: AppTheme.primaryColor,
                  size: 38,
                ),
                Text("Hapus Modul ini?", style: AppTheme.h4),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Item modul ini akan dihapus dari daftar modul.",
                  textAlign: TextAlign.center,
                  style: AppTheme.textDefault,
                ),
                Row(
                  spacing: 15,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyFilledButton(
                      title: "Batal",
                      onPressed: () {
                        Get.back();
                      },
                      backgroundColor: AppTheme.surfaceColor,
                      textColor: AppTheme.primaryColor,
                    ),
                    MyFilledButton(
                      title: "Hapus",
                      onPressed: () {},
                      backgroundColor: AppTheme.errorColor,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        break;
    }
  }
}
