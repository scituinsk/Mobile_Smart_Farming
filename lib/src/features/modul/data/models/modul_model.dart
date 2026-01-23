import 'package:pak_tani/src/features/modul/data/models/modul_feature_model.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul_feature.dart';

class ModulModel extends Modul {
  const ModulModel({
    required super.id,
    required super.name,
    super.descriptions,
    required super.serialId,
    super.features,
    required super.createdAt,
    super.image,
    super.isLocked,
  });

  factory ModulModel.fromJson(Map<String, dynamic> json) {
    return ModulModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      descriptions: json['descriptions'],
      serialId: json['serial_id'] ?? '',
      features: json['feature'] != null
          ? (json["feature"] as List<dynamic>)
                .map(
                  (featureJson) => ModulFeatureModel.fromJson(
                    featureJson as Map<String, dynamic>,
                  ),
                )
                .cast<ModulFeature>()
                .toList()
          : null,
      createdAt: json['created_at'] ?? DateTime.now(),
      image: json['image'] ?? "",
      isLocked: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'descriptions': descriptions,
      'serial_id': serialId,
      'features': features,
      'created_at': createdAt,
      'image': image,
    };
  }

  factory ModulModel.fromEntity(Modul modul) {
    return ModulModel(
      id: modul.id,
      name: modul.name,
      descriptions: modul.descriptions,
      serialId: modul.serialId,
      features: modul.features,
      createdAt: modul.createdAt,
      image: modul.image,
      isLocked: modul.isLocked,
    );
  }

  Modul toEntity() {
    return Modul(
      id: id,
      name: name,
      descriptions: descriptions,
      serialId: serialId,
      features: features,
      createdAt: createdAt,
      image: image,
      isLocked: isLocked,
    );
  }
}
