import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/relay_services.dart';
import 'package:pak_tani/src/features/modul/domain/entities/group_relay.dart';

class GroupScheduleUiController extends GetxController {
  final RelayServices relayService;
  GroupScheduleUiController(this.relayService);

  Rx<RelayGroup?> get selectedRelayGroup => relayService.selectedRelayGroup;

  RxInt relayCount = 0.obs;
  RxBool isSequential = false.obs;
  RxInt sequentialCount = 0.obs;

  RxBool isSequentialController = false.obs;
  RxInt sequentialCountController = 0.obs;
  late TextEditingController relaySequentialCountController;
  final sequentalFormKey = GlobalKey<FormState>();
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    relaySequentialCountController = TextEditingController();

    final groupId = Get.arguments;
    relayService.selectRelayGroup(groupId);

    if (selectedRelayGroup.value != null) {
      if (selectedRelayGroup.value!.relays != null) {
        relayCount.value = selectedRelayGroup.value!.relays!.length;
      }

      print("ada selected group");
      sequentialCountController.value = selectedRelayGroup.value!.sequential;
      sequentialCount.value = sequentialCountController.value;

      print("jumlah sequential: ${sequentialCount.value}");

      relaySequentialCountController.text = selectedRelayGroup.value!.sequential
          .toString();

      isSequentialController.value = sequentialCount.value != 0;
      sequentialCount.value < relayCount.value;
      isSequential.value = isSequentialController.value;

      print("apakah sequential controller: ${isSequentialController.value}");
      print("apakah sequential: ${isSequential.value}");
    } else {
      print("tidak ada selected group");
    }
  }

  Future<void> handleEditGroupSequential() async {
    final formState = sequentalFormKey.currentState;
    if (formState == null) return;
    if (!formState.validate()) {
      Get.rawSnackbar(
        title: 'Form tidak valid',
        message: 'Periksa kembali kode modul dan password.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFE53935),
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;
      if (isSequentialController.value == false) {
        await relayService.editRelayGroup(
          selectedRelayGroup.value!.id,
          sequential: 0,
        );

        isSequential.value = false;
        sequentialCount.value = 0;
        Get.back();
        Get.snackbar("Success!", "Berhasil set mode normal");
      } else {
        await relayService.editRelayGroup(
          selectedRelayGroup.value!.id,
          sequential: int.tryParse(relaySequentialCountController.text),
        );

        isSequential.value = true;
        sequentialCount.value = selectedRelayGroup.value!.sequential;

        Get.back();
        Get.snackbar(
          "Success!",
          "Berhasil set mode sequential ${relaySequentialCountController.text}",
        );
      }
    } catch (e) {
      print("error edit group sequential: $e");
      Get.snackbar("Error!", e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  void prepareSettingSheet() {
    relaySequentialCountController.text = sequentialCount.value.toString();
    isSequentialController.value = isSequential.value;
  }

  String? validateSequential(String? value) {
    final v = (value == null || value.trim().isEmpty)
        ? null
        : int.tryParse(value.trim());
    if (v == null) return 'Jumlah Sequential tidak boleh kosong';
    if (v < 1) return 'Jumlah Sequential minimal 1';
    if (v >= relayCount.value) {
      return 'harus kurang dari jumlah total solenoid';
    }
    return null;
  }
}
