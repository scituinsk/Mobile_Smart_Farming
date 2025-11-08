import 'package:equatable/equatable.dart';

class Modul extends Equatable {
  final String id;
  final String name;
  final String? descriptions;
  final String serialId;
  final List<DeviceFeature>? features;
  final String createdAt;
  final String? image;
  const Modul({
    required this.id,
    required this.name,
    this.descriptions,
    required this.serialId,
    this.features,
    required this.createdAt,
    this.image,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    descriptions,
    serialId,
    features,
    createdAt,
    image,
  ];
}

class DeviceFeature extends Equatable {
  final String name;
  final String? descriptions;
  final String data;

  const DeviceFeature({
    required this.name,
    this.descriptions,
    required this.data,
  });

  @override
  List<Object?> get props => [name, descriptions, data];

  @override
  String toString() =>
      "DeviceFeature(name: $name, description: $descriptions, )";
}
