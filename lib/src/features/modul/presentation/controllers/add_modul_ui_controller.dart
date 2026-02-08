import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/utils/my_snackbar.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_service.dart';

class AddModulUiController extends GetxController {
  final ModulService _service;
  AddModulUiController(this._service);

  late TextEditingController modulCodeController;
  late TextEditingController modulPasswordController;
  late GlobalKey<FormState> formKey;
  final isSubmitting = false.obs;
  final RxBool isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    final serialId = Get.arguments ?? "";
    print("arguments: $serialId");
    _initFormController(serialId);
  }

  void openQrScanner() {
    Get.toNamed(
      RouteNames.qrScanPage,
      arguments: (String barcode) {
        modulCodeController.text = barcode;
        print("Barcode scanned: $barcode");
      },
    );
  }

  Future<void> handleAddModul() async {
    print("kode modul: ${modulCodeController.text}");
    print("kode modul: ${modulPasswordController.text}");
    final formState = formKey.currentState;
    if (formState == null) return;
    if (!formState.validate()) {
      MySnackbar.error(
        title: "Form tidak valid",
        message: "Periksa kembali kode modul dan password.",
      );
      return;
    }

    if (isSubmitting.value) return;
    try {
      isSubmitting.value = true;
      await _service.addModul(
        modulCodeController.text.trim(),
        modulPasswordController.text.trim(),
      );
      Get.back();
      MySnackbar.success(message: "Berhasil menambahkan modul");
    } catch (e) {
      MySnackbar.error(message: e.toString());
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

  void _initFormController(String? serialId) {
    formKey = GlobalKey<FormState>();
    modulCodeController = TextEditingController(text: serialId);
    modulPasswordController = TextEditingController();

    modulCodeController.addListener(_checkFormValidity);
    modulPasswordController.addListener(_checkFormValidity);
  }

  void _disposeFormController() {
    modulCodeController.removeListener(_checkFormValidity);
    modulPasswordController.removeListener(_checkFormValidity);
    modulCodeController.dispose();
    modulPasswordController.dispose();
  }

  void _checkFormValidity() {
    final serialId = modulCodeController.text.trim();
    final password = modulPasswordController.text.trim();

    final serialIdValid = validateCode(serialId) == null && serialId.isNotEmpty;
    final passwordValid =
        validatePassword(password) == null && password.isNotEmpty;

    isFormValid.value = serialIdValid && passwordValid;
  }

  @override
  void onClose() {
    _disposeFormController();
    super.onClose();
  }
}
