import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/utils/loading_dialog.dart';
import 'package:pak_tani/src/core/utils/my_snackbar.dart';
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
  RxBool get isLoading => relayService.isLoading;

  //edit status controller
  final RxBool isEditingGroup = false.obs;
  final RxBool isEditingRelay = false.obs;

  late TextEditingController groupName;
  final formKey = GlobalKey<FormState>();

  //edit relay controller
  late FocusNode relayNameFocus;
  late FocusNode relayDescFocus;
  late TextEditingController relayNameC;
  late TextEditingController relayDescC;

  @override
  void onInit() {
    super.onInit();
    groupName = TextEditingController();
  }

  void initEditRelayDialog(String name, String? descriptions) {
    relayNameFocus = FocusNode();
    relayDescFocus = FocusNode();
    relayNameC = TextEditingController(text: name);
    relayDescC = TextEditingController(text: descriptions);
  }

  void disposeEditRelayDialog() {
    relayNameFocus.unfocus();
    relayDescFocus.unfocus();
    relayNameFocus.dispose();
    relayDescFocus.dispose();

    relayNameC.dispose();
    relayDescC.dispose();
  }

  void setEditingGroup() {
    if (!isEditingGroup.value) isEditingRelay.value = false;
    isEditingGroup.value = !isEditingGroup.value;
    Get.back();
  }

  void setEditingRelay() {
    if (!isEditingRelay.value) isEditingGroup.value = false;
    isEditingRelay.value = !isEditingRelay.value;
    Get.back();
  }

  Future<void> handleReloadRelays() async {
    if (isLoading.value) return;
    try {
      if (selectedModul.value == null) {
        throw Exception("relay_error_no_device".tr);
      }
      await relayService.loadRelaysAndAssignToRelayGroup(
        selectedModul.value!.serialId,
      );
    } catch (e) {
      print("error reload relays (controller): $e");
      MySnackbar.error(message: e.toString());
    }
  }

  Future<void> handleAddRelayGroup() async {
    final formState = formKey.currentState;
    if (formState == null) return;
    if (!formState.validate()) {
      MySnackbar.error(
        title: "form_invalid_title".tr,
        message: "relay_form_invalid_message".tr,
      );
      return;
    }

    if (isLoading.value) return;
    try {
      if (selectedModul.value != null) {
        await relayService.addRelayGroup(
          selectedModul.value!.id,
          groupName.text,
        );
        await relayService.loadRelaysAndAssignToRelayGroup(
          selectedModul.value!.serialId,
        );
        Get.back();
        MySnackbar.success(message: "relay_add_group_success".tr);
      } else {
        throw Exception('relay_error_device_not_found'.tr);
      }
    } catch (e) {
      MySnackbar.error(message: e.toString());
    }
  }

  Future<void> handleEditRelayGroupName(int id) async {
    final formState = formKey.currentState;
    if (formState == null) return;
    if (!formState.validate()) {
      MySnackbar.error(
        title: "form_invalid_title".tr,
        message: "relay_form_invalid_message".tr,
      );
      return;
    }

    if (isLoading.value) return;
    try {
      await relayService.editRelayGroup(id, name: groupName.text);

      Get.closeAllSnackbars();
      Navigator.of(Get.overlayContext!).pop();
      MySnackbar.success(message: "relay_edit_group_success".tr);
    } catch (e) {
      MySnackbar.error(message: e.toString());
    }
  }

  Future<void> handleEditRelay(int pin, int id) async {
    final formState = formKey.currentState;
    if (formState == null) return;
    if (!formState.validate()) {
      MySnackbar.error(
        title: "form_invalid_title".tr,
        message: "relay_form_invalid_check".tr,
      );
      return;
    }

    if (isLoading.value) return;
    try {
      if (selectedModul.value == null) {
        throw Exception("relay_error_device_not_found".tr);
      }

      await relayService.editRelay(
        id,
        selectedModul.value!.serialId,
        pin,
        name: relayNameC.text,
        descriptions: relayDescC.text,
      );

      await relayService.loadRelaysAndAssignToRelayGroup(
        selectedModul.value!.serialId,
      );

      Get.closeAllSnackbars();
      Navigator.of(Get.overlayContext!).pop();
      MySnackbar.success(message: "relay_edit_success".tr);
    } catch (e) {
      MySnackbar.error(message: e.toString());
    }
  }

  Future<void> deleteRelayGroup(int id) async {
    try {
      await relayService.deleteRelayGroup(id);

      Get.closeAllSnackbars();
      Navigator.of(Get.overlayContext!).pop();
      MySnackbar.success(message: "relay_delete_group_success".tr);
    } catch (e) {
      print("error (ui controller): $e");
      MySnackbar.error(message: e.toString());
    }
  }

  void initEditGroupDialog(RelayGroup relayGroup) {
    groupName.text = relayGroup.name;
  }

  void disposeRelayGroupDialog() async {
    await Future.delayed(const Duration(milliseconds: 300));
    groupName.text = "";
  }

  String? validateGroupName(String? value) {
    final v = value?.trim() ?? "";
    if (v.isEmpty) return "validation_relay_group_name_required".tr;
    if (v.length < 2) return "validation_relay_group_name_min".tr;
    if (v.length >= 20) return "validation_relay_group_name_max".tr;
    return null;
  }

  String? validateRelayName(String? value) {
    final v = value?.trim() ?? "";
    if (v.isEmpty) return "validation_relay_name_required".tr;
    if (v.length < 2) return "validation_relay_name_min".tr;
    if (v.length >= 20) return "validation_relay_name_max".tr;
    return null;
  }

  String? validateDescription(String? value) {
    final v = value?.trim() ?? "";
    if (v.length >= 1000) return "validation_modul_description_max_length".tr;
    return null;
  }

  Future<void> moveRelayWithIndices(
    int fromListIndex,
    int fromItemIndex,
    int toListIndex,
    int toItemIndex,
  ) async {
    LoadingDialog.show();
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
      LoadingDialog.hide();
    } catch (e, st) {
      LoadingDialog.hide();
      print("Failed to move relay: $e\n$st");
      MySnackbar.error(message: "relay_move_failed".tr);

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
