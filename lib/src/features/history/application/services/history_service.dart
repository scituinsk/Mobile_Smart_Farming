import 'package:get/get.dart';
import 'package:pak_tani/src/features/history/domain/entities/history.dart';
import 'package:pak_tani/src/features/history/domain/repositories/history_repository.dart';
import 'package:pak_tani/src/features/history/domain/value_objects/history_type.dart';

class HistoryService extends GetxService {
  final HistoryRepository _repository;
  HistoryService(this._repository);

  final List<History> histories = <History>[].obs;
  final RxBool isLoading = false.obs;

  /// List of scheduleGroup for filtering history.
  RxList<Map<String, dynamic>> allGroupSchedule = <Map<String, dynamic>>[].obs;

  /// List of filtered histories.
  /// This list will be shown to user.
  final RxList<History> filteredHistories = <History>[].obs;

  /// Load all history from reposiory.
  /// Sort scheduleHistory in each historyList first,
  /// then assign them to histories and filteredHistories.
  Future<void> loadAllHistories({bool refresh = false}) async {
    if (refresh) {
      histories.clear();
      filteredHistories.clear();
    }

    isLoading.value = true;
    try {
      final historyList = await _repository.getListAllHistory();
      if (historyList != null) {
        _sortScheduleHistoryAsc(historyList);
        histories.assignAll(historyList);
        filteredHistories.assignAll(historyList);
        _assignAllGroupSchedule();
        print(
          "all group schedules:${allGroupSchedule.map((element) => element["name"])}",
        );
        print("Loaded ${historyList.length} histories");
      } else {
        histories.clear();
        filteredHistories.clear();
        print("no histories found");
      }
    } catch (e) {
      print("error load histories(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Assigns all unique group schedule from histories to allGroupSchedule list.
  ///
  /// This method clears the existing allGroupSchedule list and populates it with unique
  /// schedule group IDs and their corresponding name from histories.
  void _assignAllGroupSchedule() {
    try {
      allGroupSchedule.clear();
      Set<int> uniqueIds = {};
      for (var history in histories) {
        if (history.historyType == HistoryType.schedule &&
            history.scheduleGroupId != null) {
          if (!uniqueIds.contains(history.scheduleGroupId)) {
            uniqueIds.add(history.scheduleGroupId!);
            allGroupSchedule.add({
              "id": history.scheduleGroupId,
              "name": history.name,
            });
          }
        }
      }
    } catch (e) {
      print("error assigning group schedules: $e");
      rethrow;
    }
  }

  /// Sort filteredHistory ascending by updatedAt time
  void sortHistoriesAsc() {
    try {
      filteredHistories.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
    } catch (e) {
      print("error sorting asc histories (service): $e");
      rethrow;
    }
  }

  /// Sort filteredHistory descending by updateAt time
  void sortHistoriesDesc() {
    try {
      filteredHistories.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      print("error sorting asc histories (service): $e");
      rethrow;
    }
  }

  /// Searches and filters the list of histories based on the provided query string.
  ///
  /// This method performs a case-insensitive search across the `name` and `message`
  /// fields of each history item. It clears the existing `filteredHistories` list
  /// and populates it with items that match the query.
  ///
  /// [query] The search string to filter histories by. The search is case-insensitive
  /// and checks if the query is contained within the history's name or message.
  ///
  /// Throws an exception if an error occurs during the filtering process, after
  /// logging the error message.
  /// Filter histories based on given query
  void searchHistories(String query) {
    try {
      final lowerQuery = query.toLowerCase();
      filteredHistories.clear();
      filteredHistories.addAll(
        histories.where((history) {
          final message = history.message?.toLowerCase() ?? "";
          final historyName = history.name?.toLowerCase() ?? "";
          return historyName.contains(lowerQuery) ||
              message.contains(lowerQuery);
        }),
      );
    } catch (e) {
      print("error search histories (service): $e");
      rethrow;
    }
  }

  /// Sorting scheduleHistory for each of [histories] with rule.
  ///
  ///- History with longest duration placed in first list (to ensure water pump in the first position).
  ///- Rest of history will be sorted based on start time ascending.
  List<History> _sortScheduleHistoryAsc(List<History> histories) {
    try {
      for (var history in histories) {
        if (history.scheduleHistories != null &&
            history.scheduleHistories!.isNotEmpty) {
          final durations = history.scheduleHistories!.map((s) {
            final totalEnd = s.endTime.hour * 60 + s.endTime.minute;
            final totalStart = s.startTime.hour * 60 + s.startTime.minute;
            return totalEnd - totalStart;
          }).toList();

          // search index with max duration
          int maxIndex = 0;
          int maxDuration = durations[0];
          for (var i = 1; i < durations.length; i++) {
            if (durations[i] > maxDuration) {
              maxDuration = durations[i];
              maxIndex = i;
            }
          }

          //swap item with max duration to first position
          final temp = history.scheduleHistories![0];
          history.scheduleHistories![0] = history.scheduleHistories![maxIndex];
          history.scheduleHistories![maxIndex] = temp;

          //sort the rest (from index 1) based on start time ascending.
          history.scheduleHistories!
              .sublist(1)
              .sort((a, b) => a.startTime.compareTo(b.startTime));
        }
      }

      return histories;
    } catch (e) {
      print("error sorting schedule histories asc(service): $e");
      rethrow;
    }
  }

  /// Applies combined filters for modul IDs, schedule IDs, history types, and created date range to filteredHistories.
  ///
  /// [modulIds] List of modul IDs to filter by. If null or empty, no modul filtering is applied.
  /// [scheduleIds] List of schedule group IDs to filter by. If null or empty, no schedule filtering is applied.
  /// [historyTypes] List of HistoryType to filter by. If null or empty, no type filtering is applied.
  /// [startDate] Start date for createdAt filter (inclusive). If null, no lower bound.
  /// [endDate] End date for createdAt filter (inclusive). If null, no upper bound.
  void filterHistories(
    List<int>? modulIds,
    List<int>? scheduleIds,
    List<HistoryType>? historyTypes,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    try {
      filteredHistories.assignAll(
        histories.where((history) {
          bool matchModul =
              modulIds == null ||
              modulIds.isEmpty ||
              modulIds.contains(history.modulId);
          bool matchSchedule =
              scheduleIds == null ||
              scheduleIds.isEmpty ||
              (history.scheduleGroupId != null &&
                  scheduleIds.contains(history.scheduleGroupId));
          bool matchType =
              historyTypes == null ||
              historyTypes.isEmpty ||
              historyTypes.contains(history.historyType);
          bool matchDate = true;
          if (startDate != null || endDate != null) {
            bool afterStart =
                startDate == null ||
                history.createdAt.compareTo(startDate) >= 0;
            bool beforeEnd =
                endDate == null || history.createdAt.compareTo(endDate) <= 0;
            matchDate = afterStart && beforeEnd;
          }
          return matchModul && matchSchedule && matchType && matchDate;
        }),
      );
    } catch (e) {
      print("error applying combined filters: $e");
    }
  }
}
