import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/core/widgets/search_widget.dart';

class FilterModul extends StatelessWidget {
  const FilterModul({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 17,
      children: [
        Text("Cari Modul", style: AppTheme.h4),
        Row(
          spacing: 23,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: SearchWidget()),
            MyIcon(
              iconSize: 20,
              customIcon: MyCustomIcon.filter,
              padding: 12,
              onPressed: () => print("tes"),
            ),
          ],
        ),
      ],
    );
  }
}
