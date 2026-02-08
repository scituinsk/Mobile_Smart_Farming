import 'package:pak_tani/src/features/modul/domain/entities/feature_data.dart';

class FeatureDataModel extends FeatureData {
  const FeatureDataModel({required super.name, required super.data});

  factory FeatureDataModel.fromJson(Map<String, dynamic> json) {
    return FeatureDataModel(
      name: json["name"]?.toString() ?? "", 
      data: json["data"], 
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "data": data};
  }

  factory FeatureDataModel.fromEntity(FeatureData data) {
    return FeatureDataModel(name: data.name, data: data.data);
  }

  FeatureData toEntity() {
    return FeatureData(name: name, data: data);
  }
}
