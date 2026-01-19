import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/utils/my_snackbar.dart';
import 'package:pak_tani/src/features/history/application/services/history_service.dart';
import 'package:pak_tani/src/features/history/domain/entities/history.dart';
import 'package:pak_tani/src/features/history/domain/value_objects/history_type.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_service.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';

class HistoryController extends GetxController {
  final HistoryService historyService;
  final ModulService modulService;
  HistoryController(this.historyService, this.modulService);

  /// list of filtered histories
  RxList<History> get histories => historyService.filteredHistories;

  /// list of all schedule group in map with structure:
  ///
  /// {"id": groupId, "name": groupName}.
  /// this Id is unique.
  RxList<Map<String, dynamic>> get allScheduleGroups =>
      historyService.allGroupSchedule;
  RxList<Modul> get moduls => modulService.moduls;

  //controller for sorting
  RxBool isAscending = true.obs;
  RxBool isDescending = false.obs;

  /// list of group Ids that is selected
  RxList<int> selectedFilterScheduleGroups = <int>[].obs;

  /// list of moduls that is selected
  RxList<Modul> selectedFilterModuls = <Modul>[].obs;

  /// list of historyType that is selected
  RxList<HistoryType> selectedFilterHistoryTypes = <HistoryType>[].obs;

  /// Variable to store picked start date
  Rxn<DateTime> pickedStartDate = Rxn<DateTime>(null);

  ///Variable to store picked end date
  Rxn<DateTime> pickedEndDate = Rxn<DateTime>(null);

  /// Controller for checkbox group filter
  RxBool isScheduleGroupSelectedAll = false.obs;

  ///controller for checkbox modul filter
  RxBool isModulSelectedAll = false.obs;

  /// Function for check is there [id] in [selectedFilterScheduleGroups].
  /// Return [bool] for scheduleGroup filter toogle.
  bool isScheduleGroupSelected(int id) =>
      selectedFilterScheduleGroups.contains(id);

  /// Function for check is there modul with [id] in [selectedFilterModuls].
  /// Return [bool] for modul filter toogle.
  bool isModulSelected(String id) =>
      selectedFilterModuls.any((modul) => modul.id == id);

  /// Function for check is there [historyType] in [selectedFilterHistoryTypes].
  /// Return [bool] for historyType filter toogle.
  bool isHistoryTypeSelected(HistoryType historyType) =>
      selectedFilterHistoryTypes.contains(historyType);

  /// Loading state for showing loading indicator
  RxBool get isLoading => historyService.isLoading;

  /// Refresh all history.
  /// Calling [loadAllHistory] function from [HistoryService].
  Future<void> refreshHistoryList() async {
    try {
      await historyService.loadAllHistories(refresh: true);
    } catch (e) {
      print("error: $e");
      MySnackbar.error(message: e.toString());
    }
  }

  /// Function for toogle select all modul filter check box.
  void selectAllModulFilter(bool? value) {
    if (value == null) return;
    if (value) {
      selectedFilterModuls.clear();
      selectedFilterModuls.assignAll(moduls);
      isModulSelectedAll.value = value;
    } else {
      selectedFilterModuls.clear();
      isModulSelectedAll.value = value;
    }
  }

  /// Function for toogle select all schedule group filter check box.
  void selectAllScheduleGroupFilter(bool? value) {
    if (value == null) return;
    if (value) {
      selectedFilterScheduleGroups.clear();
      selectedFilterScheduleGroups.assignAll(
        allScheduleGroups.map((element) => element["id"]),
      );
      isScheduleGroupSelectedAll.value = value;
    } else {
      selectedFilterScheduleGroups.clear();
      isScheduleGroupSelectedAll.value = value;
    }
  }

  /// Function for toogle modul filter.
  ///
  /// add [selectedModul] to [selectedFilterModuls] when there's no [selectedModul] in [selectedFilterModuls]
  /// and remove [selectedModul] from [selectedFilterModuls] when there's [selectedModul] in [selectedFilterModuls]
  void selectModulFilter(Modul selectedModul) {
    if (selectedFilterModuls.contains(selectedModul)) {
      selectedFilterModuls.remove(selectedModul);
    } else {
      selectedFilterModuls.add(selectedModul);
    }
  }

  /// Function for toogle schedule group filter.
  ///
  /// add [id] to [selectedFilterScheduleGroups] when there's no [id] in [selectedFilterScheduleGroups]
  /// and remove [id] from [selectedFilterScheduleGroups] when there's [id] in [selectedFilterScheduleGroups]
  void selectScheduleGroupFilter(int id) {
    if (selectedFilterScheduleGroups.contains(id)) {
      selectedFilterScheduleGroups.remove(id);
    } else {
      selectedFilterScheduleGroups.add(id);
    }
  }

  /// Function for toogle historyType modul filter check box.
  ///
  /// add [HistoryType.modul] to [selectedFilterHistoryTypes] when [value] is true;
  /// and remove [HistoryType.modul] from [selectedFilterHistoryTypes] when [value] is false;
  void selectModulHistoryType(bool? value) {
    if (value == null) return;
    if (value) {
      selectedFilterHistoryTypes.add(HistoryType.modul);
    } else {
      selectedFilterHistoryTypes.remove(HistoryType.modul);
    }
  }

  /// Function for toogle historyType schedule filter check box.
  ///
  /// add [HistoryType.schedule] to [selectedFilterHistoryTypes] when [value] is true;
  /// and remove [HistoryType.schedule] from [selectedFilterHistoryTypes] when [value] is false;
  void selectScheduleHistoryType(bool? value) {
    if (value == null) return;
    if (value) {
      selectedFilterHistoryTypes.add(HistoryType.schedule);
    } else {
      selectedFilterHistoryTypes.remove(HistoryType.schedule);
    }
  }

  /// Function for pick start date.
  /// Checking start date to prevent start date bigger than end date
  Future<void> pickStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    if (pickedDate != null) {
      if (pickedEndDate.value != null) {
        final compare = pickedEndDate.value!.compareTo(pickedDate);
        if (compare == 1 || compare == 0) {
          pickedStartDate.value = pickedDate;
        } else {
          MySnackbar.error(
            message: 'Start date harus lebih kecil atau sama dengan end date',
          );
          return;
        }
      }
      pickedStartDate.value = pickedDate;
    }
  }

  /// Function for pick end date.
  /// Checking end date to prevent end date smaller than start date
  Future<void> pickEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    if (pickedDate != null) {
      if (pickedStartDate.value != null) {
        final compare = pickedDate.compareTo(pickedStartDate.value!);
        if (compare == 1 || compare == 0) {
          pickedEndDate.value = pickedDate;
        } else {
          MySnackbar.error(
            message: 'End date harus lebih besar atau sama dengan start date',
          );
          return;
        }
      }
      pickedEndDate.value = pickedDate;
    }
  }

  /// function to set start date and end date null.
  void clearDatePicker() {
    pickedStartDate.value = null;
    pickedEndDate.value = null;
  }
}
