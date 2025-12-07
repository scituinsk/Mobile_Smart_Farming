import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';

class ModulListSheets {
  static Future<void> showSearchField(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Search",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Material(
                color: Colors.transparent,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: MyIcon(
                        customIcon: MyCustomIcon.search,
                        backgroundColor: Colors.transparent,
                        onPressed: () => Get.back(),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(
                        right: 15,
                        top: 5,
                        bottom: 5,
                      ),
                      child: MyIcon(
                        icon: Icons.swap_vert_rounded,
                        backgroundColor: AppTheme.surfaceColor,
                        onPressed: () => print("object"),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );
        final offset = Tween<Offset>(
          begin: const Offset(0, -1.0),
          end: Offset.zero,
        ).animate(curved);
        return SlideTransition(position: offset, child: child);
      },
    );
  }
}
