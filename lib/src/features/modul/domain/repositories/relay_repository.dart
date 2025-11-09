import 'package:pak_tani/src/features/modul/domain/entities/group_relay.dart';
import 'package:pak_tani/src/features/modul/domain/entities/relay.dart';

abstract class RelayRepository {
  Future<List<Relay>>? getListRelay(String serialId);
  Future<Relay> editRelay(
    int pin,
    String serialId, {
    String? name,
    int? groupId,
  });
  Future<List<GroupRelay>> getListGroup(String serialId);
  Future<GroupRelay> editGroup(String id);
  Future<List<GroupRelay>> insertRelaysToGroupsRelay(
    List<GroupRelay> group,
    List<Relay> relay,
  );
}
