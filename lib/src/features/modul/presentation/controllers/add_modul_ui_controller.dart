import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_controller.dart';

class AddModulUiController extends GetxController {
  final ModulController _controller;
  AddModulUiController(this._controller);

  late TextEditingController modulCodeController;
  late TextEditingController modulPasswordController;
  final formKey = GlobalKey<FormState>();
  final isSubmitting = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    modulCodeController = TextEditingController();
    modulPasswordController = TextEditingController();
  }

  Future<void> handleAddModul() async {
    print("kode modul: ${modulCodeController.text}");
    print("kode modul: ${modulPasswordController.text}");
    final formState = formKey.currentState;
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
      await _controller.addModul(
        modulCodeController.text.trim(),
        modulPasswordController.text.trim(),
      );
      Get.back();
      Get.snackbar("Success", "Berhasil menambahkan modul");
    } catch (e) {
      Get.snackbar("Error!", e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  String? validateCode(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Kode modul tidak boleh kosong';
    if (v.length < 6) return 'Kode modul minimal 6 karakter';
    return null;
  }

  String? validatePassword(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Password tidak boleh kosong';
    if (v.length < 4) return 'Password minimal 4 karakter';
    return null;
  }

  @override
  void onClose() {
    modulCodeController.dispose();
    modulPasswordController.dispose();
    super.onClose();
  }
}
