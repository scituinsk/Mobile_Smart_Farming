import 'package:get/get.dart';
import 'package:pak_tani/src/core/utils/log_utils.dart';
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
        LogUtils.d("loaded relays ${relayList.length}");
      } else {
        relays.clear();
        LogUtils.d("no device found");
      }
    } catch (e) {
      LogUtils.e("error load relays(service)", e);
      rethrow;
    }
  }

  Future<void> _loadGroupRelays(String serialId) async {
    try {
      final groupRelayList = await _repository.getRelayGroups(serialId);
      relayGroups.assignAll(groupRelayList);
      LogUtils.d("loaded relays ${groupRelayList.length}");
    } catch (e) {
      LogUtils.e("error load relays(service)", e);
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
      LogUtils.e("error load and assign relays to groups(service)", e);
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
      LogUtils.e("error editing relay(service)", e);
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
      LogUtils.e("error editing relay(service)", e);
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
      LogUtils.e("error add relay group(service)", e);
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
      LogUtils.e("Error editing relayGroup(service)", e);
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
      LogUtils.e("error removing modul", e);
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
      LogUtils.e("Error select relay group(service)", e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void applyRelayStatuses(Map<int, bool> statuses) {
    for (var gi = 0; gi < relayGroups.length; gi++) {
      final group = relayGroups[gi];
      final relays = group.relays;
      if (relays == null) continue;

      var changed = false;
      final updatedRelays = <Relay>[];

      for (var relay in relays) {
        final int pin = relay.pin;
        if (statuses.containsKey(pin)) {
          final bool newState = statuses[pin]!;
          Relay newRelay = relay;
          try {
            newRelay = relay.copyWith(status: newState);
            changed = true;
          } catch (e) {
            newRelay = relay;
          }
          updatedRelays.add(newRelay);
        } else {
          updatedRelays.add(relay);
        }
      }
      if (changed) {
        try {
          final newGroup = group.copyWith(relays: updatedRelays);
          relayGroups[gi] = newGroup;
          if (selectedRelayGroup.value?.id == newGroup.id) {
            selectedRelayGroup.value = newGroup;
            selectedRelayGroup.refresh();
          }
        } catch (e) {
          relayGroups[gi] = group;
          if (selectedRelayGroup.value?.id == group.id) {
            selectedRelayGroup.value = relayGroups[gi];
            selectedRelayGroup.refresh();
          }
        }
      }
    }
    relayGroups.refresh();
  }

  Future<void> turnOnAllRelayOnGroup(int id) async {
    isLoading.value = true;
    try {
      await _repository.turnOnAllSolenoid(id.toString());
    } catch (e) {
      LogUtils.e("error turning on all relay schedule group", e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> turnOffAllRelayOnGroup(int id) async {
    isLoading.value = true;
    try {
      await _repository.turnOffAllSolenoid(id.toString());
    } catch (e) {
      LogUtils.e("error turning off all relay schedule group", e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
