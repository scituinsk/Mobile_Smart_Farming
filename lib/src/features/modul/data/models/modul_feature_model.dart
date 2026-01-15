import 'package:pak_tani/src/features/modul/data/models/feature_data_model.dart';
import 'package:pak_tani/src/features/modul/domain/entities/feature_data.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul_feature.dart';

class ModulFeatureModel extends ModulFeature {
  const ModulFeatureModel({
    required super.name,
    super.descriptions,
    super.data,
  });

  factory ModulFeatureModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json["data"];
    List<FeatureData>? parsedData;

    if (dataJson != null && dataJson is List) {
      parsedData = dataJson
          .map(
            (item) => FeatureDataModel.fromJson(item as Map<String, dynamic>),
          )
          .cast<FeatureData>()
          .toList();
    }

    return ModulFeatureModel(
      name: json["name"],
      descriptions: json["descriptions"],
      data: parsedData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "descriptions": descriptions,
      "data": data
          ?.map((item) => FeatureDataModel.fromEntity(item).toJson())
          .toList(),
    };
  }

  factory ModulFeatureModel.fromEntity(ModulFeature feature) {
    return ModulFeatureModel(
      name: feature.name,
      descriptions: feature.descriptions,
      data: feature.data,
    );
  }

  ModulFeature toEntity() {
    return ModulFeature(name: name, descriptions: descriptions, data: data);
  }
}
