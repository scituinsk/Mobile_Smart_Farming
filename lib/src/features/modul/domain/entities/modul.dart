import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul_feature.dart';

part 'modul.g.dart';

@HiveType(typeId: 0)
class Modul extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? descriptions;
  @HiveField(3)
  final String serialId;
  @HiveField(4)
  final List<ModulFeature>? features;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final String? image;
  @HiveField(7)
  final bool? isLocked;

  const Modul({
    required this.id,
    required this.name,
    this.descriptions,
    required this.serialId,
    this.features,
    required this.createdAt,
    this.image,
    this.isLocked,
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
    isLocked,
  ];
}
