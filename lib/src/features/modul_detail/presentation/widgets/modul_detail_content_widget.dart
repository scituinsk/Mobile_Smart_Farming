import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

class ModulDetailContentWidget extends StatelessWidget {
  final String title;
  final Widget content;
  const ModulDetailContentWidget({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.textMedium),
        content,
      ],
    );
  }
}
