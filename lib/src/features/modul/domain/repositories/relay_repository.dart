import 'package:pak_tani/src/features/modul/domain/entities/group_relay.dart';
import 'package:pak_tani/src/features/modul/domain/entities/relay.dart';

abstract class RelayRepository {
  Future<List<Relay>?> getListRelay(String serialId);
  Future<Relay> editRelay(
    int pin,
    String serialId, {
    String? name,
    int? groupId,
  });
  Future<List<RelayGroup>> getRelayGroups(String serialId);
  Future<RelayGroup> editRelayGroup(int id, String name, int sequential);
  Future<List<RelayGroup>> insertRelaysToRelayGroups(
    List<RelayGroup> groups,
    List<Relay> relays,
  );
  Future<RelayGroup> addRelayGroup(String modulId, String name);
}
