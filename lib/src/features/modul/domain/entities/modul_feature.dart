import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pak_tani/src/features/modul/domain/entities/feature_data.dart';

part 'modul_feature.g.dart';

@HiveType(typeId: 1)
class ModulFeature extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String? descriptions;
  @HiveField(2)
  final List<FeatureData>? data;

  const ModulFeature({required this.name, this.descriptions, this.data});

  @override
  List<Object?> get props => [name, descriptions, data];

  @override
  String toString() =>
      "DeviceFeature(name: $name, description: $descriptions, data: $data )";
}
