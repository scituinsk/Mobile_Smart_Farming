import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/relay_services.dart';
import 'package:pak_tani/src/features/modul/domain/entities/group_relay.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/relay_controller.dart';

class RelayUiController extends GetxController {
  final RelayController _controller;
  final RelayServices _services;
  RelayUiController(this._controller, this._services);

  RxList<RelayGroup> get relayGroup => _controller.relayGroups;
  Rx<Modul?> get selectedModul => _controller.selectedModul;

  late TextEditingController groupName;
  final formKey = GlobalKey<FormState>();
  final RxBool isSubmitting = false.obs;

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

    if (isSubmitting.value) return;
    try {
      isSubmitting.value = true;
      if (selectedModul.value != null) {
        await _services.addRelayGroup(selectedModul.value!.id, groupName.text);
        Get.back();
        Get.snackbar("Success!", "Berhasil menambahkan RelayGroup");
        groupName.text = "";
      } else {
        throw Exception('Modul tidak ditemukan');
      }
    } catch (e) {
      Get.snackbar("Error!", e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  String? validateName(String? value) {
    final v = value?.trim() ?? "";
    if (v.isEmpty) return "Nama Group tidak boleh kosong";
    if (v.length < 2) return "Nama Group minimal 2 karakter";
    if (v.length >= 20) return "Nama Group maksimal 20 karakter";
    return null;
  }

  @override
  void onClose() {
    groupName.dispose();

    super.onClose();
  }
}
