import 'dart:async';

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
  RxList<Map<String, dynamic>> selectedModulGorups =
      <Map<String, dynamic>>[].obs;

  //controller for sorting
  RxBool isAscending = true.obs;

  /// list of group Ids that is selected
  RxList<Map<String, dynamic>> selectedFilterScheduleGroups =
      <Map<String, dynamic>>[].obs;

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

  /// Loading state for showing loading indicator
  RxBool get isLoading => historyService.isLoading;

  final RxString searchText = "".obs;
  late TextEditingController searchTextController;
  late FocusNode searchFocus;
  final RxBool isSearchFocused = false.obs;

  Timer? debounce;

  Modul? modulIdArg;

  @override
  void onInit() {
    super.onInit();
    searchTextController = TextEditingController();
    searchFocus = FocusNode();
    searchFocus.addListener(() {
      isSearchFocused.value = searchFocus.hasFocus;
    });
  }

  @override
  void onClose() {
    debounce?.cancel();
    searchFocus.dispose();
    searchTextController.dispose();
    super.onClose();
  }

  /// Function for check is there [id] in [selectedFilterScheduleGroups].
  /// Return [bool] for scheduleGroup filter toogle.
  bool isScheduleGroupSelected(int id) =>
      selectedFilterScheduleGroups.any((group) => group["id"] == id);

  /// Function for check is there modul with [id] in [selectedFilterModuls].
  /// Return [bool] for modul filter toogle.
  bool isModulSelected(String id) =>
      selectedFilterModuls.any((modul) => modul.id == id);

  /// Function for check is there [historyType] in [selectedFilterHistoryTypes].
  /// Return [bool] for historyType filter toogle.
  bool isHistoryTypeSelected(HistoryType historyType) =>
      selectedFilterHistoryTypes.contains(historyType);

  /// Refresh all history.
  /// Calling [loadAllHistory] function from [HistoryService].
  Future<void> refreshHistoryList() async {
    try {
      await historyService.loadAllHistories(refresh: true);
      applyFilter();
    } catch (e) {
      print("error: $e");
      MySnackbar.error(message: e.toString());
    }
  }

  void filterSelectedModulGroups() {
    final modulIds = selectedFilterModuls.map((m) => m.id).toList();
    selectedModulGorups.value = allScheduleGroups
        .where((group) => modulIds.contains(group["modulId"].toString()))
        .toList();
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
      selectedFilterScheduleGroups.clear();
      isModulSelectedAll.value = value;
    }
    filterSelectedModulGroups();
  }

  /// Function for toogle select all schedule group filter check box.
  void selectAllScheduleGroupFilter(bool? value) {
    if (value == null) return;
    if (value) {
      selectedFilterScheduleGroups.clear();
      selectedFilterScheduleGroups.assignAll(selectedModulGorups);
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
      selectedFilterScheduleGroups.removeWhere(
        (group) => selectedModul.id == group["modulId"].toString(),
      );
    } else {
      selectedFilterModuls.add(selectedModul);
    }
    filterSelectedModulGroups();
    isModulSelectedAll.value =
        selectedFilterModuls.length == moduls.length &&
        selectedFilterModuls.every((modul) => moduls.contains(modul));

    isScheduleGroupSelectedAll.value =
        selectedFilterScheduleGroups.length == selectedModulGorups.length &&
        selectedFilterScheduleGroups.every(
          (group) => selectedModulGorups.contains(group),
        ) &&
        selectedModulGorups.isNotEmpty;
  }

  /// Function for toogle schedule group filter.
  ///
  /// add [id] to [selectedFilterScheduleGroups] when there's no [id] in [selectedFilterScheduleGroups]
  /// and remove [id] from [selectedFilterScheduleGroups] when there's [id] in [selectedFilterScheduleGroups]
  void selectScheduleGroupFilter(int id) {
    final isSelected = selectedFilterScheduleGroups.any(
      (group) => group["id"] == id,
    );
    if (isSelected) {
      selectedFilterScheduleGroups.removeWhere((group) => group["id"] == id);
    } else {
      final group = allScheduleGroups.firstWhere((group) => group["id"] == id);
      if (group.isNotEmpty) {
        selectedFilterScheduleGroups.add(group);
      }
    }
    isScheduleGroupSelectedAll.value =
        selectedFilterScheduleGroups.length == selectedModulGorups.length &&
        selectedFilterScheduleGroups.every(
          (group) => selectedModulGorups.contains(group),
        );
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
      if (selectedFilterHistoryTypes.isEmpty) {
        selectedFilterModuls.clear();
        isScheduleGroupSelectedAll.value = false;
        isModulSelectedAll.value = false;
      }
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
      selectedFilterScheduleGroups.clear();
      clearDatePicker();
      if (selectedFilterHistoryTypes.isEmpty) {
        selectedFilterModuls.clear();
        isModulSelectedAll.value = false;
      }
      isScheduleGroupSelectedAll.value = false;
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

  void resetFilter() {
    selectedFilterModuls.clear();
    selectedFilterScheduleGroups.clear();
    selectedFilterHistoryTypes.clear();

    isScheduleGroupSelectedAll.value = false;
    isModulSelectedAll.value = false;
    clearDatePicker();
  }

  void applyFilter() {
    historyService.filterHistories(
      selectedFilterModuls.map((element) => element.id).toList(),
      selectedFilterScheduleGroups.map((group) => group["id"] as int).toList(),
      selectedFilterHistoryTypes,
      pickedStartDate.value,
      pickedEndDate.value,
    );

    if (isAscending.value) {
      historyService.sortHistoriesAsc();
    } else {
      historyService.sortHistoriesDesc();
    }
    Get.back();
  }

  void sortingHistories(bool? value) {
    if (value == null) return;
    isAscending.value = value;
    if (value) {
      historyService.sortHistoriesAsc();
    } else {
      historyService.sortHistoriesDesc();
    }
  }

  void onHistorySerach() {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () {
      historyService.searchHistories(searchText.value);
    });
  }

  void clearSearch() {
    searchText.value = "";
    searchTextController.clear();
    historyService.searchHistories(searchText.value);
    searchFocus.unfocus();
  }
}
