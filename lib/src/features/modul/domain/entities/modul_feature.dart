import 'package:equatable/equatable.dart';
import 'package:pak_tani/src/features/modul/domain/entities/feature_data.dart';

class ModulFeature extends Equatable {
  final String name;
  final String? descriptions;
  final List<FeatureData>? data;

  const ModulFeature({required this.name, this.descriptions, this.data});

  @override
  List<Object?> get props => [name, descriptions, data];

  @override
  String toString() =>
      "DeviceFeature(name: $name, description: $descriptions, data: $data )";
}
