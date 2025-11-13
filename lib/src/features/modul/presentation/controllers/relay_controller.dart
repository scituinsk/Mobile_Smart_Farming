import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/relay_services.dart';
import 'package:pak_tani/src/features/modul/domain/entities/group_relay.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/domain/entities/relay.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_controller.dart';

class RelayController extends GetxController {
  final RelayServices _relayServices;
  final ModulController _modulController;
  RelayController(this._relayServices, this._modulController);

  RxList<Relay> get relays => _relayServices.relays;
  RxList<RelayGroup> get relayGroups => _relayServices.relayGroups;
  Rx<Modul?> get selectedModul => _modulController.selectedModul;

  RxBool get isLoading => _relayServices.isLoading;

  Future<void> initRelayAndGroup(String serialId) async {
    try {
      await _relayServices.loadRelaysAndAssignToGroupRelays(serialId);

      //for debug
      for (var group in relayGroups) {
        print("relay group: ${group.name}");
        if (group.relays != null && group.relays!.isNotEmpty) {
          for (var relay in group.relays!) {
            print("relay group ${group.name}: ${relay.name}");
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> moveRelayWithIndices(
    int fromListIndex,
    int fromItemIndex,
    int toListIndex,
    int toItemIndex,
  ) async {
    if (relayGroups.isEmpty) return;

    final previous = relayGroups.toList();

    try {
      final sourceGroup = relayGroups[fromListIndex];
      final targetGroup = relayGroups[toListIndex];

      final sourceRelays = List<Relay>.from(sourceGroup.relays ?? []);
      if (fromListIndex < 0 || fromItemIndex >= sourceRelays.length) return;

      final moving = sourceRelays.removeAt(fromItemIndex);

      if (fromListIndex == toListIndex) {
        final updatedList = sourceRelays;

        final insertIndex = toItemIndex > updatedList.length
            ? updatedList.length
            : toItemIndex;
        updatedList.insert(insertIndex, moving);
        final updatedGroup = RelayGroup(
          id: sourceGroup.id,
          modulId: sourceGroup.modulId,
          name: sourceGroup.name,
          relays: updatedList,
        );
        relayGroups[fromListIndex] = updatedGroup;
      } else {
        final movedRelay = Relay(
          id: moving.id,
          name: moving.name,
          pin: moving.pin,
          modulId: moving.modulId,
          groupId: targetGroup.id,
        );

        final targetRelays = List<Relay>.from(targetGroup.relays ?? []);
        final insertIndex = toItemIndex > targetRelays.length
            ? targetRelays.length
            : toItemIndex;
        targetRelays.insert(insertIndex, movedRelay);

        final updatedSource = RelayGroup(
          id: sourceGroup.id,
          modulId: sourceGroup.modulId,
          name: sourceGroup.name,
          relays: sourceRelays,
        );

        final updatedTarget = RelayGroup(
          id: targetGroup.id,
          modulId: targetGroup.modulId,
          name: targetGroup.name,
          relays: targetRelays,
        );

        relayGroups[fromListIndex] = updatedSource;
        relayGroups[toListIndex] = updatedTarget;
      }

      await _relayServices.editRelayGroup(
        _modulController.selectedModul.value!.serialId,
        moving.pin,
        targetGroup.id,
      );
    } catch (e, st) {
      // rollback on error
      relayGroups.assignAll(previous);
      print("Failed to move relay: $e\n$st");
      rethrow;
    }
  }
}
