import 'package:pak_tani/src/features/modul/domain/datasources/relay_remote_datasource.dart';
import 'package:pak_tani/src/features/modul/domain/entities/group_relay.dart';
import 'package:pak_tani/src/features/modul/domain/entities/relay.dart';
import 'package:pak_tani/src/features/modul/domain/repositories/relay_repository.dart';

class RelayRepositoryImpl extends RelayRepository {
  final RelayRemoteDatasource remoteDatasource;

  RelayRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<Relay>?> getListRelay(String serialId) async {
    try {
      final listRelay = await remoteDatasource.getListRelay(serialId);

      if (listRelay != null) {
        return listRelay.map((relay) => relay.toEntity()).toList();
      }
      return null;
    } catch (e) {
      print("error get list relay(repository): $e");
      rethrow;
    }
  }

  @override
  Future<Relay> editRelay(
    int pin,
    String serialId, {
    String? name,
    int? groupId,
  }) async {
    try {
      final relay = await remoteDatasource.editRelay(
        pin,
        serialId,
        name: name,
        groupId: groupId,
      );
      return relay.toEntity();
    } catch (e) {
      print("Error edit modul(repo): $e");
      rethrow;
    }
  }

  @override
  Future<List<RelayGroup>> getRelayGroups(String serialId) async {
    try {
      final listGroup = await remoteDatasource.getListGroup(serialId);

      return listGroup.map((element) => element.toEntity()).toList();
    } catch (e) {
      print("error get list group(repo): $e");
      rethrow;
    }
  }

  @override
  Future<RelayGroup> addRelayGroup(String modulId, String name) async {
    try {
      final relayGroup = await remoteDatasource.addGroup(modulId, name);

      return relayGroup.toEntity();
    } catch (e) {
      print("error add group(repo): $e");
      rethrow;
    }
  }

  @override
  Future<RelayGroup> editRelayGroup(int id, String name, int sequential) async {
    try {
      final relayGroup = await remoteDatasource.editGroup(
        id.toString(),
        name,
        sequential,
      );
      return relayGroup.toEntity();
    } catch (e) {
      print("error edit group(repo): $e");
      rethrow;
    }
  }

  //perlu dilihat lagi
  @override
  Future<List<RelayGroup>> insertRelaysToRelayGroups(
    List<RelayGroup> groups,
    List<Relay> relays,
  ) async {
    try {
      final Map<String, List<Relay>> relaysByGroup = {};
      for (final r in relays) {
        final key = r.groupId.toString();
        relaysByGroup.putIfAbsent(key, () => []).add(r);
      }

      final updatedGroups = groups.map((g) {
        final gId = g.id.toString();
        final existing = (g.relays ?? <Relay>[]).toList();
        final toInsert = relaysByGroup[gId] ?? <Relay>[];

        final seenkeys = <String>{};
        String keyOf(Relay r) => r.id.toString();

        for (final r in existing) {
          final k = keyOf(r);
          seenkeys.add(k);
        }

        final merged = List<Relay>.from(existing);
        for (var r in toInsert) {
          final k = keyOf(r);
          if (!seenkeys.contains(k)) {
            merged.add(r);
            seenkeys.add(k);
          }
        }

        return RelayGroup(
          id: g.id,
          modulId: g.modulId,
          name: g.name,
          relays: merged,
          sequential: g.sequential,
        );
      }).toList();

      return updatedGroups;
    } catch (e) {
      print('error insertRelaysToGroupsRelay (local merge): $e');
      return groups;
    }
  }
}
