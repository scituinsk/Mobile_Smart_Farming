import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/utils/modul_feature_helper.dart';
import 'package:pak_tani/src/core/widgets/custom_icon.dart';
import 'package:pak_tani/src/core/widgets/my_icon.dart';
import 'package:pak_tani/src/features/modul/domain/entities/feature_data.dart';
import 'package:pak_tani/src/features/modul/presentation/widgets/modul_list/modul_information_data_item.dart';

class ModulInformation extends StatelessWidget {
  final MyCustomIcon customIcon;
  final String name;
  final bool isWaterPump;
  final Color iconColor;
  final List<FeatureData> featureData;

  const ModulInformation({
    super.key,
    required this.customIcon,
    required this.name,
    this.isWaterPump = false,
    this.iconColor = AppTheme.primaryColor,
    required this.featureData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        spacing: 10.r,
        children: [
          MyIcon(
            padding: 3,
            backgroundColor: AppTheme.surfaceColor,
            customIcon: customIcon,
            iconColor: iconColor,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildDataItem(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDataItem() {
    List<Widget> items = [];

    final displayData = featureData.take(2).toList();

    for (var data in displayData) {
      final featureDataFormatted = ModulFeatureHelper.getFeatureData(
        name,
        data,
      );
      if (featureDataFormatted != null) {
        items.add(ModulInformationDataItem(featureData: featureDataFormatted));
      }
    }
    if (featureData.length > 2) {
      items.add(
        Text(
          "⋯⋯⋯⋯⋯", // atau "..."
          style: AppTheme.textSmall.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      );
    }

    return items;
  }
}
