import 'package:pak_tani/src/features/relays/data/models/group_relay_model.dart';
import 'package:pak_tani/src/features/relays/data/models/relay_model.dart';

abstract class RelayRemoteDatasource {
  Future<List<RelayModel>?> getListRelay(String serialId);
  Future<RelayModel> editRelay(
    int pin,
    String serialId, {
    String? name,
    String? descriptions,
    String? type,
    bool? status,
    int? groupId,
  });
  Future<List<GroupRelayModel>> getListGroup(String serialId);
  Future<GroupRelayModel> addGroup(String modulId, String name);
  Future<GroupRelayModel> editGroup(String id, String name, int sequential);
  Future<void> deleteGroup(String id);
  Future<void> turnOnAllSolenoid(String id);
  Future<void> turnOffAllSolenoid(String id);
}
