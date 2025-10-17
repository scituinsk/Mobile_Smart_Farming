import 'package:equatable/equatable.dart';

class Modul extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String serialId;
  final List<DeviceFeature>? features;
  final String createdAt;
  const Modul({
    required this.id,
    required this.name,
    this.description,
    required this.serialId,
    this.features,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    serialId,
    features,
    createdAt,
  ];
}

class DeviceFeature extends Equatable {
  final String name;
  final String? description;
  final String data;

  const DeviceFeature({
    required this.name,
    this.description,
    required this.data,
  });

  @override
  List<Object?> get props => [name, description];

  @override
  String toString() =>
      "DeviceFeature(name: $name, description: $description, )";
}
