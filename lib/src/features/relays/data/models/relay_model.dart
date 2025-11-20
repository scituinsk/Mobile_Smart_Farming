import 'package:pak_tani/src/features/relays/domain/models/relay.dart';

class RelayModel extends Relay {
  const RelayModel({
    required super.id,
    required super.name,
    required super.pin,
    required super.groupId,
    required super.modulId,
  });

  factory RelayModel.fromJson(Map<String, dynamic> json) {
    return RelayModel(
      id: json["id"],
      name: json["name"],
      pin: json["pin"],
      groupId: json["group"],
      modulId: json["module"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "pin": pin,
      "group": groupId,
      "module": modulId,
    };
  }

  factory RelayModel.fromEntity(Relay relay) {
    return RelayModel(
      id: relay.id,
      name: relay.name,
      pin: relay.pin,
      groupId: relay.groupId,
      modulId: relay.modulId,
    );
  }

  Relay toEntity() {
    return Relay(
      id: id,
      name: name,
      pin: pin,
      modulId: modulId,
      groupId: groupId,
    );
  }
}
