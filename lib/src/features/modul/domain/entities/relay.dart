import 'package:equatable/equatable.dart';

class Relay extends Equatable {
  final int id;
  final String name;
  final int pin;
  final int modulId;
  final int groupId;
  const Relay({
    required this.id,
    required this.name,
    required this.pin,
    required this.modulId,
    required this.groupId,
  });

  @override
  List<Object?> get props => [id, name, pin, modulId, groupId];
}
