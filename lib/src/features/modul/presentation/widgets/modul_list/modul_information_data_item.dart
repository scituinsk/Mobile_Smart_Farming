import 'package:flutter/material.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/modul/domain/entities/feature_data.dart';

class ModulInformationDataItem extends StatelessWidget {
  final FeatureData featureData;
  const ModulInformationDataItem({super.key, required this.featureData});

  @override
  Widget build(BuildContext context) {
    return Text(
      "${featureData.name}: ${featureData.data}",
      style: AppTheme.h5.copyWith(color: Colors.white),
    );
  }
}
