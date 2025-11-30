import 'package:pak_tani/src/features/relays/domain/models/relay.dart';
import 'package:pak_tani/src/features/relays/domain/value_objects/relay_type.dart';

class RelayModel extends Relay {
  const RelayModel({
    required super.id,
    required super.name,
    required super.descriptions,
    required super.type,
    required super.status,
    required super.pin,
    required super.groupId,
    required super.modulId,
  });

  factory RelayModel.fromJson(Map<String, dynamic> json) {
    return RelayModel(
      id: json["id"],
      name: json["name"],
      descriptions: json["descriptions"],
      type: RelayType.fromJson(json["type"], defaultValue: RelayType.solenoid)!,
      status: json["status"],
      pin: json["pin"],
      groupId: json["group"],
      modulId: json["module"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "descriptions": descriptions,
      "type": type.toJson,
      "status": status,
      "pin": pin,
      "group": groupId,
      "module": modulId,
    };
  }

  factory RelayModel.fromEntity(Relay relay) {
    return RelayModel(
      id: relay.id,
      name: relay.name,
      descriptions: relay.descriptions,
      type: relay.type,
      status: relay.status,
      pin: relay.pin,
      groupId: relay.groupId,
      modulId: relay.modulId,
    );
  }

  Relay toEntity() {
    return Relay(
      id: id,
      name: name,
      descriptions: descriptions,
      type: type,
      status: status,
      pin: pin,
      modulId: modulId,
      groupId: groupId,
    );
  }
}
