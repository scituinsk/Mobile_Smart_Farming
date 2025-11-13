import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/domain/entities/group_relay.dart';
import 'package:pak_tani/src/features/modul/domain/entities/relay.dart';
import 'package:pak_tani/src/features/modul/domain/repositories/relay_repository.dart';

class RelayServices extends GetxService {
  final RelayRepository _repository;
  RelayServices(this._repository);

  final RxBool isLoading = false.obs;

  final RxList<Relay> relays = <Relay>[].obs;
  final RxList<RelayGroup> relayGroups = <RelayGroup>[].obs;

  Future<void> _loadRelays(String serialId) async {
    try {
      final relayList = await _repository.getListRelay(serialId);
      if (relayList != null) {
        relays.assignAll(relayList);
        print("loaded relays ${relayList.length}");
      } else {
        relays.clear();
        print("no device found");
      }
    } catch (e) {
      print("error load relays(service): $e");
      rethrow;
    }
  }

  Future<void> _loadGroupRelays(String serialId) async {
    try {
      final groupRelayList = await _repository.getRelayGroups(serialId);
      relayGroups.assignAll(groupRelayList);
      print("loaded relays ${groupRelayList.length}");
    } catch (e) {
      print("error load relays(service): $e");
      rethrow;
    }
  }

  Future<void> loadRelaysAndAssignToGroupRelays(String serialId) async {
    isLoading.value = true;
    try {
      await _loadRelays(serialId);
      await _loadGroupRelays(serialId);
      final groupRelayList = await _repository.insertRelaysToRelayGroups(
        relayGroups,
        relays,
      );

      relayGroups.assignAll(groupRelayList);
    } catch (e) {
      print("error load and assign relays to groups(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editRelayGroup(String serialId, int pin, int groupId) async {
    try {
      final relay = await _repository.editRelay(
        pin,
        serialId,
        groupId: groupId,
      );

      final index = relays.indexWhere((element) => element.pin == pin);
      print("move relays $index to $groupId");
      relays[index] = relay;
    } catch (e) {
      print("error editing modul(service): $e ");
      rethrow;
    }
  }

  Future<void> addRelayGroup(String modulId, String name) async {
    try {
      final relayGroup = await _repository.addRelayGroup(modulId, name);
      relayGroups.add(relayGroup);
    } catch (e) {
      print("error add relay group(service): $e");
      rethrow;
    }
  }
}
