import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_service.dart';
import 'package:pak_tani/src/features/relays/application/services/relay_service.dart';
import 'package:pak_tani/src/features/relays/domain/models/group_relay.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/relays/domain/models/relay.dart';

class RelayUiController extends GetxController {
  final RelayService _relayService;

  final ModulService _modulService;
  RelayUiController(this._relayService, this._modulService);

  RxList<RelayGroup> get relayGroups => _relayService.relayGroups;
  Rx<Modul?> get selectedModul => _modulService.selectedModul;
  RxBool get isLoading => _modulService.isLoading;

  late TextEditingController groupName;
  final formKey = GlobalKey<FormState>();
  // final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    groupName = TextEditingController();
  }

  Future<void> handleAddRelayGroup() async {
    final formState = formKey.currentState;
    if (formState == null) return;
    if (!formState.validate()) {
      Get.snackbar("From tidak valid", "Periksa kembali nama RelayGroup");
      return;
    }

    if (isLoading.value) return;
    try {
      if (selectedModul.value != null) {
        await _relayService.addRelayGroup(
          selectedModul.value!.id,
          groupName.text,
        );
        Get.back();
        Get.snackbar("Success!", "Berhasil menambahkan RelayGroup");
        groupName.text = "";
      } else {
        throw Exception('Modul tidak ditemukan');
      }
    } catch (e) {
      Get.snackbar("Error!", e.toString());
    }
  }

  String? validateName(String? value) {
    final v = value?.trim() ?? "";
    if (v.isEmpty) return "Nama Group tidak boleh kosong";
    if (v.length < 2) return "Nama Group minimal 2 karakter";
    if (v.length >= 20) return "Nama Group maksimal 20 karakter";
    return null;
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
          sequential: sourceGroup.sequential,
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
          sequential: sourceGroup.sequential,
        );

        final updatedTarget = RelayGroup(
          id: targetGroup.id,
          modulId: targetGroup.modulId,
          name: targetGroup.name,
          relays: targetRelays,
          sequential: targetGroup.sequential,
        );

        relayGroups[fromListIndex] = updatedSource;
        relayGroups[toListIndex] = updatedTarget;
      }

      await _relayService.editGroupForRelay(
        _modulService.selectedModul.value!.serialId,
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

  @override
  void onClose() {
    groupName.dispose();

    super.onClose();
  }
}
