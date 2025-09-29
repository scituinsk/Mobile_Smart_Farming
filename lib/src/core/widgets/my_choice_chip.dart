import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class MyChoiceChip extends StatelessWidget {
  final bool selected;
  final String title;
  const MyChoiceChip({super.key, required this.selected, required this.title});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        title,
        style: AppTheme.text.copyWith(
          color: selected ? Colors.white : AppTheme.primaryColor,
        ),
      ),
      onSelected: (value) {},
      selected: selected,
      showCheckmark: false,
      backgroundColor: Colors.white,
      selectedColor: AppTheme.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.transparent),
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    );
  }
}
