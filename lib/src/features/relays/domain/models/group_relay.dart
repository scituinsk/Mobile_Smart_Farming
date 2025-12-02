import 'package:equatable/equatable.dart';
import 'package:pak_tani/src/features/relays/domain/models/relay.dart';

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

  RelayGroup copyWith({
    int? id,
    int? modulId,
    String? name,
    List<Relay>? relays,
    int? sequential,
  }) {
    return RelayGroup(
      id: id ?? this.id,
      modulId: modulId ?? this.modulId,
      name: name ?? this.name,
      relays: relays ?? this.relays,
      sequential: sequential ?? this.sequential,
    );
  }
}
