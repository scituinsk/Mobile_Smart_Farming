import 'package:pak_tani/src/features/modul/domain/entities/group_relay.dart';

class GroupRelayModel extends GroupRelay {
  const GroupRelayModel({
    required super.id,
    required super.name,
    required super.modulId,
    super.relays,
  });

  factory GroupRelayModel.fromJson(Map<String, dynamic> json) {
    return GroupRelayModel(
      id: json["id"],
      name: json["name"],
      modulId: json["modul"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "modul": modulId};
  }

  factory GroupRelayModel.fromEntity(GroupRelay group) {
    return GroupRelayModel(
      id: group.id,
      modulId: group.modulId,
      name: group.name,
    );
  }

  GroupRelay toEntity() {
    return GroupRelay(id: id, modulId: modulId, name: name);
  }
}
