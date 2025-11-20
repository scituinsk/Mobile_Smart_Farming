import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/modul_feature_helper.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/modul/domain/entities/feature_data.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_detail/modul_feature_data_item.dart';

class ModulDetailDataItem extends StatelessWidget {
  final MyCustomIcon myCustomIcon;
  final String title;
  final String rawName;
  final String descriptions;
  final List<FeatureData>? data;
  final Color color;

  const ModulDetailDataItem({
    super.key,
    required this.myCustomIcon,
    required this.title,
    required this.rawName,
    required this.data,
    required this.descriptions,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              MyIcon(
                customIcon: myCustomIcon,
                iconColor: color,
                backgroundColor: color.withValues(alpha: 0.2),
              ),
              Text(title, style: AppTheme.h4),
            ],
          ),
          Text(descriptions, style: AppTheme.textAction),
          if (data != null)
            ...data!.map(
              (modulData) => ModulFeatureDataItem(
                featureData: ModulFeatureHelper.getFeatureData(
                  rawName,
                  modulData,
                )!,
                color: ModulFeatureHelper.getFeatureColor(rawName),
              ),
            ),
        ],
      ),
    );
  }
}
