import 'package:pak_tani/src/features/relays/domain/models/group_relay.dart';

class GroupRelayModel extends RelayGroup {
  const GroupRelayModel({
    required super.id,
    required super.name,
    required super.modulId,
    super.relays,
    required super.sequential,
  });

  factory GroupRelayModel.fromJson(Map<String, dynamic> json) {
    return GroupRelayModel(
      id: json["id"],
      name: json["name"],
      modulId: json["modul"],
      sequential: json["sequential"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "modul": modulId};
  }

  factory GroupRelayModel.fromEntity(RelayGroup group) {
    return GroupRelayModel(
      id: group.id,
      modulId: group.modulId,
      name: group.name,
      sequential: group.sequential,
    );
  }

  RelayGroup toEntity() {
    return RelayGroup(
      id: id,
      modulId: modulId,
      name: name,
      sequential: sequential,
    );
  }
}
