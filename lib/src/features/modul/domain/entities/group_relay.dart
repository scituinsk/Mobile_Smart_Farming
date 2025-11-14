import 'package:equatable/equatable.dart';
import 'package:pak_tani/src/features/modul/domain/entities/relay.dart';

class RelayGroup extends Equatable {
  final int id;
  final int modulId;
  final String name;
  final List<Relay>? relays;
  final int sequential;
  const RelayGroup({
    required this.id,
    required this.modulId,
    required this.name,
    this.relays,
    required this.sequential,
  });

  @override
  List<Object?> get props => [id, modulId, name, relays, sequential];
}
