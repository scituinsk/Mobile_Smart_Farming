import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/widgets/my_snackbar.dart';
import 'package:pak_tani/src/features/relays/domain/value_objects/relay_type.dart';
import 'package:pak_tani/src/features/schedule/application/services/schedule_service.dart';
import 'package:pak_tani/src/features/schedule/domain/entities/schedule.dart';
import 'package:pak_tani/src/features/schedule/domain/value_objects/week_day.dart';
import 'package:pak_tani/src/features/relays/application/services/relay_service.dart';
import 'package:pak_tani/src/features/relays/domain/models/group_relay.dart';

class ScheduleUiController extends GetxController {
  final RelayService relayService;
  final ScheduleService scheduleService;
  ScheduleUiController(this.relayService, this.scheduleService);

  Rx<RelayGroup?> get selectedRelayGroup => relayService.selectedRelayGroup;
  RxList<Schedule> get schedules => scheduleService.schedules;
  RxBool get isFetchingSchedule => scheduleService.isFetching;
  RxBool get isSavingSchedule => scheduleService.isSaving;
  RxBool get isDeletingSchedule => scheduleService.isDeleting;

  RxInt relayCount = 0.obs;
  RxInt solenoidCount = 0.obs;
  RxBool isSequential = false.obs;
  RxInt sequentialCount = 0.obs;

  //sequential controller
  RxBool isSequentialController = false.obs;
  RxInt sequentialCountController = 0.obs;
  late TextEditingController relaySequentialCountController;
  final sequentalFormKey = GlobalKey<FormState>();
  final isSubmittingSequential = false.obs;

  //schedule controller
  late FocusNode scheduleDurationFocus;
  Rxn<TimeOfDay> timeController = Rxn<TimeOfDay>(null);
  late TextEditingController scheduleDurationController;
  final RxSet<WeekDay> selectedDays = <WeekDay>{}.obs;
  final GlobalKey<FormState> scheduleFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
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

  void initAddScheduleSheet() {
    scheduleDurationFocus = FocusNode();
    scheduleDurationController = TextEditingController();
  }

  void initEditScheduleSheet(Schedule schedule) {
    scheduleDurationFocus = FocusNode();
    timeController.value = schedule.time;
    scheduleDurationController = TextEditingController(
      text: schedule.duration.toString(),
    );
    loadDaysFromSchedule(schedule);
  }

  void disposeScheduleSheet() {
    scheduleDurationFocus.unfocus();
    scheduleDurationFocus.dispose();
    scheduleDurationController.dispose();
    timeController.value = null;
    clearDays();
  }

  Future<void> handleEditGroupSequential() async {
    final formState = sequentalFormKey.currentState;
    if (formState == null || !formState.validate()) {
      MySnackbar.error(
        message: "Form tidak valid. Periksa kembali input Anda.",
      );
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
        MySnackbar.success(message: "Berhasil set mode normal");
      } else {
        await relayService.editRelayGroup(
          selectedRelayGroup.value!.id,
          sequential: int.tryParse(relaySequentialCountController.text),
        );

        isSequential.value = true;
        sequentialCount.value = selectedRelayGroup.value!.sequential;

        Get.back();

        MySnackbar.success(
          message:
              "Berhasil set mode sequential ${relaySequentialCountController.text}",
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
      MySnackbar.error(
        message: "Form tidak valid. Periksa kembali input Anda.",
      );
      return;
    }

    if (timeController.value == null) {
      MySnackbar.error(message: "Waktu belum dipilih");
      return;
    }
    if (selectedDays.isEmpty) {
      MySnackbar.error(message: "Pilih minimal 1 hari");
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
      MySnackbar.success(message: "Jadwal ditambahkan");
    } catch (e) {
      MySnackbar.error(message: e.toString());
    }
  }

  Future<void> handleEditSchedule(int id) async {
    if (timeController.value == null) {
      MySnackbar.error(message: "Waktu belum dipilih");
      return;
    }
    if (selectedDays.isEmpty) {
      MySnackbar.error(message: "Pilih minimal 1 hari");
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
      MySnackbar.success(message: "Jadwal ditambahkan");
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
      MySnackbar.success(message: "Berhasi menghapus schedule");
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
    if (v > solenoidCount.value) {
      return 'harus kurang dari jumlah total solenoid';
    }
    return null;
  }

  String? validateDuration(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final v = int.tryParse(value.trim());

    if (v == null) {
      return 'Harap masukkan angka yang valid.';
    }

    if (v < 0) {
      return 'Durasi tidak boleh kurang dari 0.';
    }

    if (v > 720) {
      return 'Durasi tidak boleh lebih dari 720.';
    }

    return null;
  }
}
