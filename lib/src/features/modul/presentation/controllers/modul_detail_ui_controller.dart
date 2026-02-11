import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/services/device_ws_service.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/core/services/web_socket_service.dart';
import 'package:pak_tani/src/core/utils/my_snackbar.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_service.dart';
import 'package:pak_tani/src/features/relays/application/services/relay_service.dart';
import 'package:pak_tani/src/features/modul/domain/entities/feature_data.dart';
import 'package:pak_tani/src/features/relays/domain/models/group_relay.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul_feature.dart';

class ModulDetailUiController extends GetxController
    with WidgetsBindingObserver {
  final ModulService _modulService;
  final RelayService _relayService;
  ModulDetailUiController(this._modulService, this._relayService);

  Rx<Modul?> get modul => _modulService.selectedModul;
  RxList<RelayGroup> get relayGroups => _relayService.relayGroups;

  bool _pendingListUpdate = false;
  Modul? _lastUpdatedModul;

  final RxBool isLoading = false.obs;

  Rxn<File> selectedImage = Rxn<File>(null);

  late Map<String, dynamic> arguments;
  late String serialId;
  late int? scheduleGroupId;

  final ws = Rxn<DeviceWsService>();
  StreamSubscription? _sub;

  Timer? _streamTimer;

  final _storage = Get.find<StorageService>();
  final _wsService = Get.find<WebSocketService>();

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
  final RxBool isQrVisible = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    isLoading.value = true;
    try {
      arguments = await Get.arguments;
      serialId = arguments["serial_id"];
      scheduleGroupId = arguments["schedule"];
      await getDevice(serialId);
      print("selected device: ${modul.value!.name}");

      _initFormController();

      await _relayService.loadRelaysAndAssignToRelayGroup(
        modul.value!.serialId,
      );
      await _initWsStream();
      if (scheduleGroupId != null) {
        if (scheduleGroupId! > 0) {
          Get.toNamed(RouteNames.groupSchedulePage, arguments: scheduleGroupId);
        }
      }
    } catch (e) {
      _modulService.loadModuls(refresh: true);
      Get.back();
      print("error at detail init: $e");
      MySnackbar.error(message: e.toString());
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
      // print("selected image changed: ${selectedImage.value!.path}");
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

    await _sub?.cancel();
    _streamTimer?.cancel();

    final handle =
        ws.value ??
        await _wsService.getOrOpenDeviceStream(token: token, modulId: serialId);

    if (ws.value == null) {
      ws.value = handle;
    }

    await _sub?.cancel();

    _sub = handle.stream.listen(
      (raw) {
        try {
          final json = jsonDecode(raw) as Map<String, dynamic>;

          _updateFeatureData(json);

          _updateRelayStatusFromWs(json);
        } catch (e) {
          print("parse error: $e | raw=$raw");
        }
      },
      onError: (e) {
        print('WS error: $e');
        _cancelStreamTimer();
      },
      onDone: () {
        print('WS selesai');
        _cancelStreamTimer();
        ws.value = null;
      },
      cancelOnError: false,
    );

    try {
      ws.value?.send("GET_SENSOR");
    } catch (e) {
      print('WS send GET_SENSOR failed: $e');
    }

    _streamTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (ws.value == null) {
        print("Timer stopped: ws is null");
        timer.cancel();
        return;
      }

      try {
        ws.value?.send("GET_SENSOR");
      } catch (e) {
        print('WS send GET_SENSOR failed: $e');
        timer.cancel();
      }
    });
  }

  void _updateFeatureData(Map<String, dynamic> wsData) {
    final currentModul = modul.value;
    if (currentModul?.features == null) return;

    final updatedFeatures = currentModul!.features!.map((feature) {
      List<FeatureData>? updatedFeatureData = feature.data != null
          ? List.from(feature.data!)
          : null;

      List<dynamic>? wsFeatureData;
      switch (feature.name.toLowerCase()) {
        case 'temperature':
          wsFeatureData = wsData['temperature_data'] as List<dynamic>?;
          break;
        case 'humidity':
          wsFeatureData = wsData['humidity_data'] as List<dynamic>?;
          break;
        case 'water_level':
          wsFeatureData = wsData['water_level_data'] as List<dynamic>?;
          break;
        case 'battery':
          wsFeatureData = wsData['battery_data'] as List<dynamic>?;
          break;
      }

      if (wsFeatureData != null && wsFeatureData.isNotEmpty) {
        updatedFeatureData = wsFeatureData.map((item) {
          final itemMap = item as Map<String, dynamic>;
          return FeatureData(name: itemMap["name"], data: itemMap["data"]);
        }).toList();
      }

      return ModulFeature(
        name: feature.name,
        data: updatedFeatureData,
        descriptions: feature.descriptions,
      );
    }).toList();

    final Modul updatedModul = Modul(
      id: currentModul.id,
      name: currentModul.name,
      descriptions: currentModul.descriptions,
      serialId: currentModul.serialId,
      features: updatedFeatures,
      createdAt: currentModul.createdAt,
      image: currentModul.image,
      isLocked: currentModul.isLocked,
    );

    //update only the selected device to void rebuilding main modules
    _modulService.selectedModul.value = updatedModul;
    _modulService.selectedModul.refresh();

    _lastUpdatedModul = updatedModul;
    _pendingListUpdate = true;

    update();
  }

  void _updateRelayStatusFromWs(Map<String, dynamic> wsData) {
    final Map<int, bool> statuses = {};

    final dynamic scheduleData = wsData["schedule_data"];
    List<dynamic>? pinsList;

    if (scheduleData is List) {
      for (var item in scheduleData) {
        if (item is Map && item.containsKey("pins")) {
          pinsList = (item["pins"] as List<dynamic>?);
          break;
        }
      }
    } else if (scheduleData is Map) {
      pinsList = (scheduleData["pins"] as List<dynamic>?);
    }

    // 2) If we got a pins list, parse it: each item like {"10":"1"}
    if (pinsList != null && pinsList.isNotEmpty) {
      for (final item in pinsList) {
        if (item is Map) {
          item.forEach((k, v) {
            final int? pin = int.tryParse(k.toString());
            if (pin == null) return;

            int? intVal;
            if (v is int) {
              intVal = v;
            } else {
              intVal = int.tryParse(v?.toString() ?? '');
            }

            if (intVal == null) return;
            statuses[pin] = intVal == 1;
          });
        }
      }
    } else {
      // 3) Fallback: maybe wsData itself is a map of pin->0/1 (legacy)
      wsData.forEach((key, value) {
        final int? pin = int.tryParse(key);
        if (pin == null) return;

        int? intVal;
        if (value is int) {
          intVal = value;
        } else {
          intVal = int.tryParse(value?.toString() ?? '');
        }

        if (intVal == null) return;
        statuses[pin] = intVal == 1;
      });
    }

    if (statuses.isEmpty) return;

    _relayService.applyRelayStatuses(statuses);
    update();
  }

  Future<void> getDevice(String id) async {
    await _modulService.loadModul(id);
  }

  Future<void> deleteDevice() async {
    try {
      await _modulService.deleteModul(modul.value!.serialId);
      Get.back();
      MySnackbar.success(message: "delete_device_from_user_success".tr);
    } catch (e) {
      print("error (ui controller): $e");
      MySnackbar.error(message: e.toString());
    }
  }

  Future<void> handleEditModul() async {
    final formState = formKeyEdit.currentState;
    if (formState == null) return;
    if (!formState.validate()) {
      MySnackbar.error(
        title: "form_invalid_title".tr,
        message: "form_invalid_message".tr,
      );
      return;
    }

    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;
      await _modulService.editModul(
        modul.value!.serialId,
        name: modulNameC.text.trim(),
        description: modulDescriptionC.text.trim(),
        imageFile: selectedImage.value,
      );
      await _modulService.loadModul(modul.value!.serialId);

      Get.back();
      MySnackbar.success(message: "edit_device_success".tr);
    } catch (e) {
      MySnackbar.error(message: e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> handleEditPassword() async {
    final formState = formKeyPassword.currentState;
    if (formState == null) return;
    if (!formState.validate()) {
      Get.snackbar(
        "form_invalid_title".tr,
        "form_invalid_message".tr,
        backgroundColor: Colors.red.shade600,
        duration: Duration(seconds: 2),
      );
      return;
    }

    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;
      await _modulService.editModul(
        modul.value!.serialId,
        password: modulNewPassC.text.trim(),
      );
      await _modulService.loadModul(modul.value!.serialId);

      Get.back();
      MySnackbar.success(message: "edit_password_success".tr);
    } catch (e) {
      MySnackbar.error(message: e.toString());
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
    if (v.isEmpty) return "validation_modul_name_required".tr;
    if (v.length < 3) return "validation_modul_name_min_length".tr;
    if (v.length >= 20) return "validation_modul_name_max_length".tr;
    return null;
  }

  String? validateDescription(String? value) {
    final v = value?.trim() ?? "";
    if (v.length >= 1000) return "validation_modul_description_max_length".tr;
    return null;
  }

  String? validatePassword(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'validation_device_password_required'.tr;
    if (v.length < 4) return 'validation_device_password_min_length'.tr;
    return null;
  }

  String? validateConfirmPassword(String? value) {
    final v = value?.trim() ?? '';
    final newPass = modulNewPassC.text.trim();

    if (newPass.isEmpty) return 'validation_new_password_required'.tr;
    if (v.isEmpty) return 'validation_confirm_password_required'.tr;
    if (v.length < 4) return 'validation_device_password_min_length'.tr;
    if (v != newPass) return 'validation_password_confirm_mismatch'.tr;
    return null;
  }

  void _cancelStreamTimer() {
    if (_streamTimer != null && _streamTimer!.isActive) {
      print("timer dimatikan");
      _streamTimer!.cancel();
      _streamTimer = null;
    }
  }

  @override
  Future<void> onClose() async {
    WidgetsBinding.instance.removeObserver(this);
    _streamTimer?.cancel();

    await _sub?.cancel();

    if (ws.value != null) {
      await _wsService.closeDeviceStream(serialId);
      ws.value = null;
    }

    if (_pendingListUpdate && _lastUpdatedModul != null) {
      final idx = _modulService.moduls.indexWhere(
        (modul) => modul.serialId == _lastUpdatedModul!.serialId,
      );
      if (idx != -1) {
        _modulService.moduls[idx] = _lastUpdatedModul!;
      }
      _pendingListUpdate = false;
      _lastUpdatedModul = null;
    }

    _disposeFormController();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print("🔄 Reconnecting WS from Lifecycle...");

      ws.value = null;
      _initWsStream();
    }
  }
}
