import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_service.dart';
import 'package:pak_tani/src/features/relays/application/services/relay_service.dart';
import 'package:pak_tani/src/features/relays/domain/models/group_relay.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/relays/domain/models/relay.dart';

class RelayUiController extends GetxController {
  final RelayService relayService;

  final ModulService _modulService;
  RelayUiController(this.relayService, this._modulService);

  RxList<RelayGroup> get relayGroups => relayService.relayGroups;
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
        await relayService.addRelayGroup(
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
    if (selectedModul.value == null) return;

    final unassignedRelays = relayService.getUnassignedRelays();
    final hasUnassignedList = unassignedRelays.isNotEmpty;

    int? fromGroupId;
    int? toGroupId;
    Relay movingRelay;

    try {
      if (hasUnassignedList) {
        if (fromListIndex == 0) {
          fromGroupId = null;
          movingRelay = unassignedRelays[fromItemIndex];
        } else {
          final adjustedFromIndex = fromListIndex - 1;
          fromGroupId = relayGroups[adjustedFromIndex].id;
          movingRelay = relayGroups[adjustedFromIndex].relays![fromItemIndex];
        }

        if (toListIndex == 0) {
          toGroupId = null;
        } else {
          final adjustedToIndex = toListIndex - 1;
          toGroupId = relayGroups[adjustedToIndex].id;
        }
      } else {
        fromGroupId = relayGroups[fromListIndex].id;
        toGroupId = relayGroups[toListIndex].id;
        movingRelay = relayGroups[fromListIndex].relays![fromItemIndex];
      }
      print(
        "Moving relay ${movingRelay.name} (pin ${movingRelay.pin}) from group $fromGroupId to $toGroupId",
      );

      if (toGroupId == null) {
        // Unassign relay (remove from group)
        await relayService.editGroupForRelay(
          selectedModul.value!.serialId,
          movingRelay.pin,
          0, // 0 = unassign (sesuaikan dengan API kamu)
        );
      } else {
        // Assign/move to new group
        await relayService.editGroupForRelay(
          selectedModul.value!.serialId,
          movingRelay.pin,
          toGroupId,
        );
      }

      // ✅ Reload data untuk refresh UI
      await relayService.loadRelaysAndAssignToRelayGroup(
        selectedModul.value!.serialId,
      );
    } catch (e, st) {
      print("Failed to move relay: $e\n$st");
      Get.snackbar("Error!", "Gagal memindahkan relay");

      // Rollback sudah di-handle oleh reload
      await relayService.loadRelaysAndAssignToRelayGroup(
        selectedModul.value!.serialId,
      );
    }
  }

  @override
  void onClose() {
    groupName.dispose();

    super.onClose();
  }
}
