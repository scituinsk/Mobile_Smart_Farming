import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';

class ModulModel extends Modul {
  const ModulModel({
    required super.id,
    required super.name,
    super.description,
    required super.serialId,
    super.features,
    required super.createdAt,
  });

  factory ModulModel.fromJson(Map<String, dynamic> json) {
    return ModulModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'],
      serialId: json['serial_id'] ?? '',
      features: _parseFeatures(json['feature']),
      createdAt: json['created_at'] ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'serial_id': serialId,
      'features': features,
      'created_at': createdAt,
    };
  }

  factory ModulModel.fromEntity(Modul user) {
    return ModulModel(
      id: user.id,
      name: user.name,
      description: user.description,
      serialId: user.serialId,
      features: user.features,
      createdAt: user.createdAt,
    );
  }

  Modul toEntity() {
    return Modul(
      id: id,
      name: name,
      description: description,
      serialId: serialId,
      features: features,
      createdAt: createdAt,
    );
  }

  static List<DeviceFeature>? _parseFeatures(dynamic value) {
    if (value == null) return null;

    if (value is! List) {
      print("features is not a list: ${value.runtimeType}");
      return null;
    }

    final List<dynamic> featureList = value;
    final List<DeviceFeature> features = [];

    for (var featureItem in featureList) {
      try {
        final feature = DeviceFeature(
          name: featureItem['name'].toString(),
          description: featureItem["descriptions"]?.toString(),
          data: featureItem['data'].toString(),
        );
        features.add(feature);
        print("parsed feature: ${feature.name}");
      } catch (e) {
        print("error parsing feature: $e");
        continue;
      }
    }
    print('✅ Successfully parsed ${features.length} features');
    return features.isEmpty ? null : features;
  }
}
