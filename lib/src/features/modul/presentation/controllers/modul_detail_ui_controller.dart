import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/core/services/web_socket_service.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul_data.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_controller.dart';

class ModulDetailUiController extends GetxController {
  final _controller = Get.find<ModulController>();
  Rx<Modul?> get modul => _controller.selectedDevice;
  final RxBool isLoading = false.obs;

  Rxn<File> selectedImage = Rxn<File>(null);

  late String modulId;

  final _ws = Rxn<DeviceWsHandle>();
  StreamSubscription? _sub;

  final _storage = Get.find<StorageService>();
  final _wsService = Get.find<WebSocketService>();

  final Rxn<ModulData> modulData = Rxn<ModulData>();

  // edit modul text editing controller
  late TextEditingController modulNameC;
  late TextEditingController modulDescriptionC;
  late TextEditingController modulNewPassC;
  late TextEditingController modulConfirmNewPassC;

  late GlobalKey<FormState> formKeyEdit;
  late GlobalKey<FormState> formKeyPassword;

  final RxBool isSubmitting = false.obs;
  final RxBool isPasswordFormValid = false.obs;
  final RxBool isEditFormValid = false.obs;

  Worker? _imageWorker;

  final RxBool isTitleExpanded = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading.value = true;
    try {
      modulId = await Get.arguments;
      await getDevice(modulId);
      print("selected device: ${modul.value!.name}");

      _initFormController();

      await _initWsStream();
    } catch (e) {
      print("error at detail init: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _initFormController() {
    print("mulai init textcontroller");
    formKeyEdit = GlobalKey<FormState>();
    formKeyPassword = GlobalKey<FormState>();
    modulNameC = TextEditingController(text: modul.value?.name);
    modulDescriptionC = TextEditingController(text: modul.value?.descriptions);
    modulNewPassC = TextEditingController();
    modulConfirmNewPassC = TextEditingController();

    modulNameC.addListener(_checkEditFormValidity);
    modulDescriptionC.addListener(_checkEditFormValidity);
    modulNewPassC.addListener(_checkPasswordFormValidity);
    modulConfirmNewPassC.addListener(_checkPasswordFormValidity);

    _imageWorker = ever(selectedImage, (_) {
      print("selected image changed: ${selectedImage.value!.path}");
      _checkEditFormValidity();
    });
  }

  void _disposeFormController() {
    print("mulai dispose textcontroller");
    modulNameC.removeListener(_checkEditFormValidity);
    modulDescriptionC.removeListener(_checkEditFormValidity);
    modulNewPassC.removeListener(_checkPasswordFormValidity);
    modulConfirmNewPassC.removeListener(_checkPasswordFormValidity);

    _imageWorker?.dispose();

    modulNameC.dispose();
    modulDescriptionC.dispose();
    modulNewPassC.dispose();
    modulConfirmNewPassC.dispose();
  }

  Future<void> _initWsStream() async {
    final token = await _storage.readSecure("access_token");
    if (token == null || token.isEmpty) {
      print("token tidak ditemukan");
      return;
    }

    final handle = await _wsService.openDeviceStream(
      token: token,
      modulId: modulId,
    );
    _ws.value = handle;

    _sub = handle.stream.listen(
      (raw) {
        try {
          final json = jsonDecode(raw as String) as Map<String, dynamic>;
          final data = ModulData.fromJson(json);
          modulData.value = data;

          print(
            "T=${data.temperature}, H=${data.humidity}, B=${data.battery}, W=${data.waterLevel}",
          );
        } catch (e) {
          print("parse error: $e | raw=$raw");
        }
      },
      onError: (e) => print('WS error: $e'),
      onDone: () => print('WS selesai'),
      cancelOnError: false,
    );

    _ws.value?.send("STREAMING_ON");
  }

  Future<void> getDevice(String id) async {
    await _controller.getSelectedModul(id);
  }

  Future<void> deleteDevice() async {
    try {
      await _controller.deleteModul(modul.value!.serialId);
      Get.back();
      Get.snackbar("success", "berhasil menghapus modul dari user ini");
    } catch (e) {
      print("error (ui controller): $e");
      Get.snackbar("Error!", e.toString());
    }
  }

  Future<void> pickAndCropImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    //pick file
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    print("berhasil memilih file: $pickedFile");
    if (pickedFile != null) {
      print("memulai crop iamge:");
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 590, ratioY: 390),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Crop Gambar",
            toolbarColor: AppTheme.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
            hideBottomControls: false,
            aspectRatioPresets: [CropAspectRatioPreset.original],
          ),
        ],
        compressQuality: 80,
      );
      if (croppedFile != null) {
        selectedImage.value = File(croppedFile.path);
      }
    }
  }

  Future<void> handleEditModul() async {
    final formState = formKeyEdit.currentState;
    if (formState == null) return;
    if (!formState.validate()) {
      Get.snackbar(
        "Form tidak valid",
        "Periksa kembali kode modul dan password",
        backgroundColor: Colors.red.shade600,
        duration: Duration(seconds: 2),
      );
      return;
    }

    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;
      await _controller.editModul(
        modul.value!.serialId,
        name: modulNameC.text.trim(),
        description: modulDescriptionC.text.trim(),
        imageFile: selectedImage.value,
      );
      await _controller.getSelectedModul(modul.value!.serialId);

      Get.back();
      Get.snackbar("Success", "Berhasil mengubah modul");
    } catch (e) {
      Get.snackbar("Error!", e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> handleEditPassword() async {
    final formState = formKeyPassword.currentState;
    if (formState == null) return;
    if (!formState.validate()) {
      Get.snackbar(
        "Form tidak valid",
        "Periksa kembali kode modul dan password",
        backgroundColor: Colors.red.shade600,
        duration: Duration(seconds: 2),
      );
      return;
    }

    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;
      await _controller.editPasswordModul(
        modul.value!.serialId,
        password: modulNewPassC.text.trim(),
      );
      await _controller.getSelectedModul(modul.value!.serialId);

      Get.back();
      Get.snackbar("Success", "Berhasil mengubah password modul");
    } catch (e) {
      Get.snackbar("Error!", e.toString());
    } finally {
      isSubmitting.value = false;
      modulNewPassC.text = "";
      modulConfirmNewPassC.text = "";
    }
  }

  void _checkEditFormValidity() {
    final name = modulNameC.text.trim();
    final descriptions = modulDescriptionC.text.trim();

    final currentModul = modul.value;
    if (currentModul == null) {
      isEditFormValid.value = false;
      return;
    }

    final originalName = currentModul.name;
    final originalDesc = currentModul.descriptions ?? '';

    // cek apakah ada perubahan yang layak disubmit
    final hasChange =
        name != originalName ||
        descriptions != originalDesc ||
        selectedImage.value != null;

    // validasi nama menggunakan validator yang sudah ada
    final nameValid = validateName(name) == null;

    // aktifkan tombol jika ada perubahan, nama valid, dan tidak sedang submit
    isEditFormValid.value = hasChange && nameValid && !isSubmitting.value;
  }

  void _checkPasswordFormValidity() {
    final newPass = modulNewPassC.text.trim();
    final confirmPass = modulConfirmNewPassC.text.trim();

    final newPassValid = validatePassword(newPass) == null;
    final confirmPassValid = validateConfirmPassword(confirmPass) == null;

    isPasswordFormValid.value =
        newPassValid && confirmPassValid && !isSubmitting.value;
  }

  String? validateName(String? value) {
    final v = value?.trim() ?? "";
    if (v.isEmpty) return "Nama tidak boleh kosong";
    if (v.length < 3) return "Nama modul minimal 3 karakter";
    return null;
  }

  String? validatePassword(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Password tidak boleh kosong';
    if (v.length < 4) return 'Password minimal 4 karakter';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    final v = value?.trim() ?? '';
    final newPass = modulNewPassC.text.trim();

    if (newPass.isEmpty) return 'Password baru tidak boleh kosong';
    if (v.isEmpty) return 'Konfirmasi password tidak boleh kosong';
    if (v.length < 4) return 'Password minimal 4 karakter';
    if (v != newPass) return 'Password dan konfirmasi tidak sama';
    return null;
  }

  @override
  Future<void> onClose() async {
    _ws.value?.send("STREAMING_OFF");
    await _sub?.cancel();
    await _ws.value?.close(); // berhenti streaming saat dispose

    _disposeFormController();
    super.onClose();
  }
}
