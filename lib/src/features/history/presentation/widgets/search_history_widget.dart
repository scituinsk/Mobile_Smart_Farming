import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/history/presentation/controllers/history_controller.dart';
import 'package:pak_tani/src/features/history/presentation/widgets/history_sheet.dart';

class SearchHistoryWidget extends StatelessWidget {
  const SearchHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();

    return Column(
      spacing: 12.r,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Cari Riwayat", style: AppTheme.h5),
        TextField(
          onChanged: (value) {
            controller.searchText.value = value;
            controller.onHistorySerach();
          },
          controller: controller.searchTextController,
          focusNode: controller.searchFocus,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(10.0.r),
              child: MyIcon(
                customIcon: MyCustomIcon.search,
                backgroundColor: Colors.transparent,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.r),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.w),
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: Obx(() {
                if (controller.searchText.value.trim().isNotEmpty &&
                    controller.isSearchFocused.value) {
                  return MyIcon(
                    icon: Icons.clear,
                    onPressed: controller.clearSearch,
                  );
                }
                return Row(
                  spacing: 8.r,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyIcon(
                      icon: Icons.swap_vert_rounded,
                      backgroundColor: AppTheme.surfaceColor,
                      onPressed: () async =>
                          await HistorySheet.showSortingSheet(context),
                    ),
                    MyIcon(
                      icon: Icons.filter_alt,
                      backgroundColor: AppTheme.surfaceColor,
                      onPressed: () async =>
                          await HistorySheet.showFilterSheet(context),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
