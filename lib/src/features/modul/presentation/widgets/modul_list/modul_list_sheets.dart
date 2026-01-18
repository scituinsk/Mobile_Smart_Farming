import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';
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
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              child: Material(
                color: Colors.transparent,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(10.0.r),
                      child: MyIcon(
                        customIcon: MyCustomIcon.search,
                        backgroundColor: Colors.transparent,
                        onPressed: () => Get.back(),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.r),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16.w,
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(
                        right: 15.w,
                        top: 5.h,
                        bottom: 5.h,
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
