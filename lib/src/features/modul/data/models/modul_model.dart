import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';

class ModulModel extends Modul {
  const ModulModel({
    required super.id,
    required super.name,
    super.descriptions,
    required super.serialId,
    super.features,
    required super.createdAt,
    super.image,
  });

  factory ModulModel.fromJson(Map<String, dynamic> json) {
    return ModulModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      descriptions: json['descriptions'],
      serialId: json['serial_id'] ?? '',
      features: _parseFeatures(json['feature']),
      createdAt: json['created_at'] ?? DateTime.now(),
      image: json['image'] ?? "",
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
          descriptions: featureItem["descriptions"]?.toString(),
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
