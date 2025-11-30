import 'package:equatable/equatable.dart';
import 'package:pak_tani/src/features/relays/domain/value_objects/relay_type.dart';

class Relay extends Equatable {
  final int id;
  final String name;
  final String? descriptions;
  final RelayType type;
  final bool status;
  final int pin;
  final int modulId;
  final int? groupId;
  const Relay({
    required this.id,
    required this.name,
    this.descriptions,
    required this.type,
    required this.status,
    required this.pin,
    required this.modulId,
    required this.groupId,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    descriptions,
    type,
    status,
    pin,
    modulId,
    groupId,
  ];
}
