import 'package:equatable/equatable.dart';

class FeatureData extends Equatable {
  final String name;
  final dynamic data;
  const FeatureData({required this.name, required this.data});

  @override
  List<Object?> get props => [name, data];
}
