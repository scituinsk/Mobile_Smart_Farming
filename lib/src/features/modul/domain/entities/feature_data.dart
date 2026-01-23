import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'feature_data.g.dart';

@HiveType(typeId: 2)
class FeatureData extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final dynamic data;

  const FeatureData({required this.name, required this.data});

  @override
  List<Object?> get props => [name, data];
}
