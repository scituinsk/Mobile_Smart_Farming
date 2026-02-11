import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/utils/log_utils.dart';
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

  /// Schedule groups that belong to selected modules
  RxList<Map<String, dynamic>> selectedModulGroups =
      <Map<String, dynamic>>[].obs;

  //controller for sorting
  RxBool isAscending = false.obs;

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
    LogUtils.d("dispose history controller");
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

  /// Refreshes the history list by loading all histories from the [HistoryService].
  ///
  /// If [isNavigating] is true, it adds [HistoryType.modul] and [HistoryType.schedule]
  /// to the selected filter history types, and adds the provided [modulArgs] to the
  /// selected filter modules. Then applies the filter and updates the UI.
  ///
  /// Throws an exception if loading histories fails, displaying an error snackbar.
  ///
  /// Parameters:
  /// - [isNavigating]: Optional boolean indicating if navigation is occurring.
  /// - [modulArgs]: Optional [Modul] object to add to filters if navigating.
  /// Refresh all history.
  /// Calling [loadAllHistory] function from [HistoryService].
  Future<void> refreshHistoryList({
    bool? isNavigating,
    Modul? modulArgs,
  }) async {
    try {
      await historyService.loadAllHistories(refresh: true);
      if (isNavigating != null) {
        if (isNavigating) {
          selectModulHistoryType(true);
          selectScheduleHistoryType(true);
          selectModulFilter(modulArgs!);
        }
      }
      applyFilter();
      historyService.searchHistories(searchText.value);
      update();
    } catch (e) {
      LogUtils.e("error", e);
      MySnackbar.error(message: e.toString());
    }
  }

  /// Filters the selected module groups based on the currently selected filter modules.
  ///
  /// This method retrieves the IDs of the selected filter modules, then filters
  /// the `allScheduleGroups` list to include only those groups whose `modulId`
  /// (converted to string) matches any of the selected module IDs. The filtered
  /// list is then assigned to `selectedModulGroups.value`.
  void filterSelectedModulGroups() {
    final modulIds = selectedFilterModuls.map((m) => m.id).toList();
    selectedModulGroups.value = allScheduleGroups
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
      selectedFilterScheduleGroups.assignAll(selectedModulGroups);
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
        selectedFilterScheduleGroups.length == selectedModulGroups.length &&
        selectedFilterScheduleGroups.every(
          (group) => selectedModulGroups.contains(group),
        ) &&
        selectedModulGroups.isNotEmpty;
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
        selectedFilterScheduleGroups.length == selectedModulGroups.length &&
        selectedFilterScheduleGroups.every(
          (group) => selectedModulGroups.contains(group),
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
          MySnackbar.error(message: 'validation_start_date_before_end'.tr);
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
          MySnackbar.error(message: 'validation_end_date_after_start'.tr);
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

  /// reset filter controller.
  ///
  /// clear [selectedFilterModuls], [selectedFilterScheduleGroups], [selectedFilterHistoryTypes].
  /// Set [isScheduleGroupSelectedAll] and [isModulSelectedAll] to false.
  /// Clear date picker
  void resetFilter() {
    selectedFilterModuls.clear();
    selectedFilterScheduleGroups.clear();
    selectedFilterHistoryTypes.clear();

    isScheduleGroupSelectedAll.value = false;
    isModulSelectedAll.value = false;
    clearDatePicker();
  }

  /// Apply all filter that been selected
  void applyFilter() {
    LogUtils.d(
      "selected history type: ${selectedFilterHistoryTypes.map((element) => element.label)}",
    );
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

  /// Function onChange for sorting histories
  void sortingHistories(bool? value) {
    if (value == null) return;
    isAscending.value = value;
    if (value) {
      historyService.sortHistoriesAsc();
    } else {
      historyService.sortHistoriesDesc();
    }
  }

  /// Function debounce for searching history
  void onHistorySerach() {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () {
      historyService.searchHistories(searchText.value);
    });
  }

  /// Function for clear search button
  void clearSearch() {
    searchText.value = "";
    searchTextController.clear();
    historyService.searchHistories(searchText.value);
    searchFocus.unfocus();
  }
}
