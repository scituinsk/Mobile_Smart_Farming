import 'package:get/get.dart';
import 'package:pak_tani/src/features/relays/domain/models/group_relay.dart';
import 'package:pak_tani/src/features/relays/domain/models/relay.dart';
import 'package:pak_tani/src/features/relays/domain/repositories/relay_repository.dart';

class RelayService extends GetxService {
  final RelayRepository _repository;
  RelayService(this._repository);

  final RxBool isLoading = false.obs;

  final RxList<Relay> relays = <Relay>[].obs;
  final RxList<RelayGroup> relayGroups = <RelayGroup>[].obs;
  final Rx<RelayGroup?> selectedRelayGroup = Rx<RelayGroup?>(null);

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

  List<Relay> getUnassignedRelays() {
    return relays.where((r) => r.groupId == null).toList();
  }

  Future<void> loadRelaysAndAssignToRelayGroup(String serialId) async {
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

  Future<void> editGroupForRelay(String serialId, int pin, int groupId) async {
    try {
      final relay = await _repository.editRelay(
        pin,
        serialId,
        groupId: groupId,
      );

      final indexRelay = relays.indexWhere((element) => element.pin == pin);
      relays[indexRelay] = relay;
    } catch (e) {
      print("error editing relay(service): $e ");
      rethrow;
    }
  }

  Future<void> editRelay(
    int id,
    String serialId,
    int pin, {
    String? name,
    String? descriptions,
  }) async {
    isLoading.value = true;

    try {
      final relay = await _repository.editRelay(
        pin,
        serialId,
        name: name,
        descriptions: descriptions,
      );

      final index = relays.indexWhere((element) => element.id == id);
      relays[index] = relay;
    } catch (e) {
      print("error editing relay(service): $e ");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addRelayGroup(String modulId, String name) async {
    isLoading.value = true;
    try {
      final relayGroup = await _repository.addRelayGroup(modulId, name);
      relayGroups.add(relayGroup);
    } catch (e) {
      print("error add relay group(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editRelayGroup(int id, {String? name, int? sequential}) async {
    isLoading.value = true;
    try {
      final relayGroupIndex = relayGroups.indexWhere(
        (element) => element.id == id,
      );
      if (relayGroupIndex == -1) {
        throw Exception("RelayGroup tidak ditemukan");
      }

      final RelayGroup current = relayGroups[relayGroupIndex];
      final updatedName = name ?? current.name;
      final updatedSequential = sequential ?? current.sequential;

      final response = await _repository.editRelayGroup(
        id,
        updatedName,
        updatedSequential,
      );

      final RelayGroup newRelayGroup = RelayGroup(
        id: response.id,
        modulId: response.modulId,
        name: response.name,
        sequential: response.sequential,
        relays: current.relays,
      );

      relayGroups[relayGroupIndex] = newRelayGroup;
      selectedRelayGroup.value = newRelayGroup;
    } catch (e) {
      print("Error editing relayGroup(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteRelayGroup(int id) async {
    isLoading.value = true;
    try {
      await _repository.deleteRelayGroup(id.toString());
      relayGroups.removeWhere((element) => element.id == id);
    } catch (e) {
      print("error removing modul: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void selectRelayGroup(int id) {
    isLoading.value = true;
    try {
      final relayGroup = relayGroups.firstWhereOrNull(
        (element) => element.id == id,
      );
      if (relayGroup != null) {
        selectedRelayGroup.value = relayGroup;
      } else {
        throw Exception("RelayGroup tidak ditemukan");
      }
    } catch (e) {
      print("Error select relay group(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
