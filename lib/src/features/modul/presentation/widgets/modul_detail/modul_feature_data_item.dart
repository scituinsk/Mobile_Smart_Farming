import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_display_chip.dart';
import 'package:pak_tani/src/features/modul/domain/entities/feature_data.dart';

class ModulFeatureDataItem extends StatelessWidget {
  final FeatureData featureData;
  final Color color;
  const ModulFeatureDataItem({
    super.key,
    required this.featureData,
    this.color = AppTheme.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(featureData.name, style: AppTheme.h5)),
          MyDisplayChip(
            backgroundColor: color.withValues(alpha: 0.2),
            child: Text(
              featureData.data.toString(),
              style: AppTheme.h5.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
