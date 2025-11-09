import 'package:equatable/equatable.dart';
import 'package:pak_tani/src/features/modul/domain/entities/relay.dart';

class GroupRelay extends Equatable {
  final int id;
  final int modulId;
  final String name;
  final List<Relay>? relays;
  const GroupRelay({
    required this.id,
    required this.modulId,
    required this.name,
    this.relays,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, modulId, name, relays];
}
