import 'package:pak_tani/src/features/modul/data/datasource/relay_remote_datasource.dart';
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
  }) {
    // TODO: implement editRelay
    throw UnimplementedError();
  }

  @override
  Future<List<GroupRelay>> getListGroup(String serialId) {
    // TODO: implement getListGroup
    throw UnimplementedError();
  }

  @override
  Future<GroupRelay> editGroup(String id) {
    // TODO: implement editGroup
    throw UnimplementedError();
  }

  @override
  Future<List<GroupRelay>> insertRelaysToGroupsRelay(
    List<GroupRelay> group,
    List<Relay> relay,
  ) {
    // TODO: implement insertRelaysToGroupsRelay
    throw UnimplementedError();
  }
}
