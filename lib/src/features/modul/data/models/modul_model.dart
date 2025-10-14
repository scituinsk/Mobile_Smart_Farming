import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';

class ModulModel extends Modul {
  ModulModel({
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
      features: json['feature'],
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
}
