import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';

class SearchHistoryWidget extends StatelessWidget {
  const SearchHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Cari Riwayat", style: AppTheme.h5),
        TextFormField(
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: MyIcon(
                customIcon: MyCustomIcon.search,
                backgroundColor: Colors.transparent,
                onPressed: () => print("object"),
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
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyIcon(
                    icon: Icons.swap_vert_rounded,
                    backgroundColor: AppTheme.surfaceColor,
                    onPressed: () => print("object"),
                  ),
                  MyIcon(
                    icon: Icons.filter_alt,
                    backgroundColor: AppTheme.surfaceColor,
                    onPressed: () => print("object"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
