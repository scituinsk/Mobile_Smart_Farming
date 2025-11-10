import 'package:equatable/equatable.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul_feature.dart';

class Modul extends Equatable {
  final String id;
  final String name;
  final String? descriptions;
  final String serialId;
  final List<ModulFeature>? features;
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
