import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/services/device_ws_service.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/core/services/web_socket_service.dart';
import 'package:pak_tani/src/core/utils/my_snackbar.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_service.dart';
import 'package:pak_tani/src/features/relays/domain/value_objects/relay_type.dart';
import 'package:pak_tani/src/features/schedule/application/services/schedule_service.dart';
import 'package:pak_tani/src/features/schedule/domain/entities/schedule.dart';
import 'package:pak_tani/src/features/schedule/domain/value_objects/week_day.dart';
import 'package:pak_tani/src/features/relays/application/services/relay_service.dart';
import 'package:pak_tani/src/features/relays/domain/models/group_relay.dart';

class ScheduleUiController extends GetxController {
  final RelayService relayService;
  final ScheduleService scheduleService;
  final ModulService modulService;
  ScheduleUiController(
    this.relayService,
    this.scheduleService,
    this.modulService,
  );

  Rx<RelayGroup?> get selectedRelayGroup => relayService.selectedRelayGroup;
  RxList<Schedule> get schedules => scheduleService.schedules;
  RxBool get isFetchingSchedule => scheduleService.isFetching;
  RxBool get isSavingSchedule => scheduleService.isSaving;
  RxBool get isDeletingSchedule => scheduleService.isDeleting;

  RxBool isLoadingTurnOn = false.obs;
  RxBool isLoadingTurnOff = false.obs;

  RxInt relayCount = 0.obs;
  RxInt solenoidCount = 0.obs;
  RxBool isSequential = false.obs;
  RxInt sequentialCount = 0.obs;

  //sequential controller
  RxBool isSequentialController = false.obs;
  RxInt sequentialCountController = 0.obs;
  late TextEditingController relaySequentialCountController;
  final isFormValid = false.obs;

  final sequentalFormKey = GlobalKey<FormState>();
  final isSubmittingSequential = false.obs;

  //schedule controller
  late FocusNode scheduleDurationFocus;
  Rxn<TimeOfDay> timeController = Rxn<TimeOfDay>(null);
  late TextEditingController scheduleDurationController;
  final RxSet<WeekDay> selectedDays = <WeekDay>{}.obs;
  final GlobalKey<FormState> scheduleFormKey = GlobalKey<FormState>();

  final _ws = Rxn<DeviceWsService>();

  // get service instance (use DI or Get.find if registered)
  final WebSocketService _wsService = Get.find<WebSocketService>();

  @override
  void onInit() {
    super.onInit();
    try {
      relaySequentialCountController = TextEditingController();
      final groupId = Get.arguments;

      relayService.selectRelayGroup(groupId);
      scheduleService.loadSchedules(groupId);

      //inisialisai infromasi group relay
      if (selectedRelayGroup.value != null) {
        if (selectedRelayGroup.value!.relays != null) {
          relayCount.value = selectedRelayGroup.value!.relays!.length;
          solenoidCount.value = selectedRelayGroup.value!.relays!
              .where((relay) => relay.type == RelayType.solenoid)
              .length;
        }

        sequentialCountController.value = selectedRelayGroup.value!.sequential;
        sequentialCount.value = sequentialCountController.value;

        relaySequentialCountController.text = selectedRelayGroup
            .value!
            .sequential
            .toString();

        isSequentialController.value = sequentialCount.value != 0;
        sequentialCount.value < relayCount.value;
        isSequential.value = isSequentialController.value;

        _initWsHandle();
      } else {
        print("tidak ada selected group");
      }
    } catch (e) {
      print("error init schedule ui: ${e.toString()}");
      MySnackbar.error(message: e.toString());
    }
  }

  Future<void> _initWsHandle() async {
    try {
      final serialId = modulService.selectedModul.value!.serialId;

      // replace with your storage service to read token
      final storage =
          Get.find<StorageService>(); // <-- ganti dengan StorageService type
      final token = await storage.readSecure("access_token");
      if (token == null || token.isEmpty) {
        print('WS: token not available');
        return;
      }

      final handle = await _wsService.getOrOpenDeviceStream(
        token: token,
        modulId: serialId,
      );

      // store handle to use for sending
      _ws.value = handle;
    } catch (e) {
      print('init ws handle error: $e');
    }
  }

  void initAddScheduleSheet() {
    scheduleDurationFocus = FocusNode();
    scheduleDurationController = TextEditingController();
    scheduleDurationController.addListener(_checkFormValidity);
  }

  void initEditScheduleSheet(Schedule schedule) {
    scheduleDurationFocus = FocusNode();
    timeController.value = schedule.time;
    scheduleDurationController = TextEditingController(
      text: schedule.duration.toString(),
    );
    scheduleDurationController.addListener(_checkFormValidity);

    loadDaysFromSchedule(schedule);
  }

  void disposeScheduleSheet() {
    scheduleDurationController.removeListener(_checkFormValidity);
    scheduleDurationFocus.unfocus();
    scheduleDurationFocus.dispose();
    scheduleDurationController.dispose();
    timeController.value = null;
    clearDays();
  }

  Future<void> handleRefreshSchedule() async {
    try {
      if (selectedRelayGroup.value == null) {
        throw Exception("error_group_not_found".tr);
      }
      if (modulService.selectedModul.value == null) {
        throw Exception("error_device_not_found".tr);
      }

      await scheduleService.loadSchedules(selectedRelayGroup.value!.id);
      await relayService.loadRelaysAndAssignToRelayGroup(
        modulService.selectedModul.value!.serialId,
      );
    } catch (e) {
      print("error refresh schedule: $e");
      MySnackbar.error(message: e.toString());
    }
  }

  Future<void> handleEditGroupSequential() async {
    final formState = sequentalFormKey.currentState;
    if (formState == null || !formState.validate()) {
      MySnackbar.error(message: "error_form_invalid".tr);
      return;
    }
    if (isSubmittingSequential.value) return;

    try {
      isSubmittingSequential.value = true;
      if (isSequentialController.value == false) {
        await relayService.editRelayGroup(
          selectedRelayGroup.value!.id,
          sequential: 0,
        );

        isSequential.value = false;
        sequentialCount.value = 0;
        Get.back();
        MySnackbar.success(message: "success_set_normal_mode".tr);
      } else {
        await relayService.editRelayGroup(
          selectedRelayGroup.value!.id,
          sequential: int.tryParse(relaySequentialCountController.text),
        );

        isSequential.value = true;
        sequentialCount.value = selectedRelayGroup.value!.sequential;

        Get.back();

        MySnackbar.success(
          message: "success_set_sequential_mode".trParams({
            'val': relaySequentialCountController.text,
          }),
        );
      }
    } catch (e) {
      print("error edit group sequential: $e");
      MySnackbar.error(message: e.toString());
    } finally {
      isSubmittingSequential.value = false;
    }
  }

  void toggleDay(WeekDay day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
    selectedDays.refresh();
  }

  bool isDaySelected(WeekDay day) => selectedDays.contains(day);

  void clearDays() => selectedDays.clear();

  void selectAllDays() {
    selectedDays
      ..clear()
      ..addAll(WeekDay.values);
    selectedDays.refresh();
  }

  void loadDaysFromSchedule(Schedule s) {
    selectedDays.clear();
    if (s.repeatMonday) selectedDays.add(WeekDay.mon);
    if (s.repeatTuesday) selectedDays.add(WeekDay.tue);
    if (s.repeatWednesday) selectedDays.add(WeekDay.wed);
    if (s.repeatThursday) selectedDays.add(WeekDay.thu);
    if (s.repeatFriday) selectedDays.add(WeekDay.fri);
    if (s.repeatSaturday) selectedDays.add(WeekDay.sat);
    if (s.repeatSunday) selectedDays.add(WeekDay.sun);
    selectedDays.refresh();
  }

  Map<String, bool> get repeatFlags {
    return {
      'repeatMonday': selectedDays.contains(WeekDay.mon),
      'repeatTuesday': selectedDays.contains(WeekDay.tue),
      'repeatWednesday': selectedDays.contains(WeekDay.wed),
      'repeatThursday': selectedDays.contains(WeekDay.thu),
      'repeatFriday': selectedDays.contains(WeekDay.fri),
      'repeatSaturday': selectedDays.contains(WeekDay.sat),
      'repeatSunday': selectedDays.contains(WeekDay.sun),
    };
  }

  Future<void> handleAddNewSchedule() async {
    final formState = scheduleFormKey.currentState;
    if (formState == null || !formState.validate()) {
      MySnackbar.error(message: "error_form_invalid".tr);
      return;
    }

    if (timeController.value == null) {
      MySnackbar.error(message: "error_time_not_selected".tr);
      return;
    }
    if (selectedDays.isEmpty) {
      MySnackbar.error(message: "error_day_not_selected".tr);
      return;
    }
    try {
      final flags = repeatFlags;
      await scheduleService.addNewSchedule(
        selectedRelayGroup.value!.id,
        time: timeController.value!,
        duration: int.tryParse(scheduleDurationController.text),
        repeatMonday: flags['repeatMonday'],
        repeatTuesday: flags['repeatTuesday'],
        repeatWednesday: flags['repeatWednesday'],
        repeatThursday: flags['repeatThursday'],
        repeatFriday: flags['repeatFriday'],
        repeatSaturday: flags['repeatSaturday'],
        repeatSunday: flags['repeatSunday'],
      );
      Get.closeAllSnackbars();

      Navigator.of(Get.overlayContext!).pop();
      await Future.delayed(const Duration(milliseconds: 150));
      MySnackbar.success(message: "success_schedule_added".tr);
    } catch (e) {
      MySnackbar.error(message: e.toString());
    }
  }

  Future<void> handleEditSchedule(int id) async {
    if (timeController.value == null) {
      MySnackbar.error(message: "error_time_not_selected".tr);
      return;
    }
    if (selectedDays.isEmpty) {
      MySnackbar.error(message: "error_day_not_selected".tr);
      return;
    }
    try {
      final flags = repeatFlags;
      await scheduleService.editSchedule(
        id,
        time: timeController.value!,
        duration: int.tryParse(scheduleDurationController.text),
        repeatMonday: flags['repeatMonday'],
        repeatTuesday: flags['repeatTuesday'],
        repeatWednesday: flags['repeatWednesday'],
        repeatThursday: flags['repeatThursday'],
        repeatFriday: flags['repeatFriday'],
        repeatSaturday: flags['repeatSaturday'],
        repeatSunday: flags['repeatSunday'],
      );
      Get.closeAllSnackbars();

      Navigator.of(Get.overlayContext!).pop();
      await Future.delayed(const Duration(milliseconds: 150));
      MySnackbar.success(message: "success_schedule_updated".tr);
    } catch (e) {
      MySnackbar.error(message: e.toString());
    }
  }

  Future<void> handleDeleteSchedule(int id) async {
    try {
      await scheduleService.deleteSchedule(id);
      Get.closeAllSnackbars();
      Navigator.of(Get.overlayContext!).pop();
      Navigator.of(Get.overlayContext!).pop();
      MySnackbar.success(message: "success_schedule_deleted".tr);
    } catch (e) {
      MySnackbar.error(message: e.toString());
    }
  }

  int getScheduleIndex(int id) {
    return schedules.indexWhere((element) => element.id == id);
  }

  Future<void> handleEditStatusSchedule(int id, bool isActive) async {
    try {
      await scheduleService.editStatusSchedule(id, isActive);
    } catch (e) {
      MySnackbar.error(message: e.toString());
    }
  }

  Future<void> _ensureWsHandle() async {
    if (_ws.value != null) return;
    try {
      final serialId = modulService.selectedModul.value!.serialId;
      final storage = Get.find<StorageService>();
      final token = await storage.readSecure("access_token");
      if (token == null || token.isEmpty) {
        print('WS: token not available (ensure)');
        return;
      }
      final handle = await _wsService.getOrOpenDeviceStream(
        token: token,
        modulId: serialId,
      );
      _ws.value = handle;
      print('WS: handle obtained for modul $serialId');
    } catch (e) {
      print('WS: ensure handle failed: $e');
    }
  }

  Future<void> _sendToDevice(String payload) async {
    try {
      // ensure we have a handle
      await _ensureWsHandle();
      final handle = _ws.value;
      if (handle == null) {
        MySnackbar.error(message: "ws_error_connection".tr);
        print('WS: send aborted - no handle');
        return;
      }

      // log payload
      print('WS SEND: $payload');

      // try send and await if channel expects future
      try {
        handle.send(payload);
        // some implementations return Future or not; await if Future
      } catch (e) {
        print('WS send error (first attempt): $e');
        // try reconnect once then resend
        try {
          final serialId = modulService.selectedModul.value!.serialId;
          final storage = Get.find<StorageService>();
          final token = await storage.readSecure("access_token");
          if (token != null) {
            final newHandle = await _wsService.getOrOpenDeviceStream(
              token: token,
              modulId: serialId,
            );
            _ws.value = newHandle;
            print('WS: re-obtained handle, retry send');
            newHandle.send(payload);
          } else {
            rethrow;
          }
        } catch (e2) {
          print('WS send error (retry): $e2');
          rethrow;
        }
      }
    } catch (e) {
      MySnackbar.error(
        message: "ws_error_send".trParams({'error': e.toString()}),
      );
    }
  }

  Future<void> handleTurnOnAllRelayInGroup() async {
    isLoadingTurnOn.value = true;
    try {
      if (selectedRelayGroup.value == null ||
          selectedRelayGroup.value!.relays == null ||
          selectedRelayGroup.value!.relays!.isEmpty) {
        MySnackbar.error(message: "error_no_relay_in_group".tr);
        return;
      }
      final String relays = selectedRelayGroup.value!.relays!
          .map((relay) => relay.pin)
          .join(',');

      final int sequential = selectedRelayGroup.value!.sequential;

      final data = [
        'check=0',
        'relay=$relays',
        'time=600',
        'schedule=0',
        'sequential=$sequential',
      ].join('\n');

      await _sendToDevice(data);

      Get.closeAllSnackbars();
      Navigator.of(Get.overlayContext!).pop();
      MySnackbar.success(message: "success_turn_on_all".tr);
    } catch (e) {
      MySnackbar.error(message: e.toString());
    } finally {
      isLoadingTurnOn.value = false;
    }
  }

  Future<void> handleTurnOffAllRelayInGroup() async {
    isLoadingTurnOff.value = true;
    try {
      if (selectedRelayGroup.value == null ||
          selectedRelayGroup.value!.relays == null ||
          selectedRelayGroup.value!.relays!.isEmpty) {
        MySnackbar.error(message: "error_no_relay_in_group".tr);
        return;
      }

      await _sendToDevice("OFF");

      Get.closeAllSnackbars();
      Navigator.of(Get.overlayContext!).pop();

      MySnackbar.success(message: "success_turn_off_all".tr);
    } catch (e) {
      MySnackbar.error(message: e.toString());
    } finally {
      isLoadingTurnOff.value = false;
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
    if (v == null) return 'val_seq_empty'.tr;
    if (v < 1) return 'val_seq_min'.tr;
    if (v > solenoidCount.value) {
      return 'val_seq_max'.tr;
    }
    return null;
  }

  String? validateDuration(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "val_dur_empty".tr;
    }
    final v = int.tryParse(value.trim());

    if (v == null) return 'val_dur_invalid'.tr;
    if (v < 1) return 'val_dur_min'.tr;
    if (v > 720) return 'val_dur_max'.tr;

    return null;
  }

  void _checkFormValidity() {
    final duration = scheduleDurationController.text.trim();

    final durationValid =
        validateDuration(duration) == null && duration.isNotEmpty;

    isFormValid.value = durationValid;
    print("isformvalid: ${isFormValid.value}");
  }
}
