import 'package:get/get.dart';
import 'package:pak_tani/src/features/history/domain/entities/history.dart';
import 'package:pak_tani/src/features/history/domain/repositories/history_repository.dart';

class HistoryService extends GetxService {
  final HistoryRepository _repository;
  HistoryService(this._repository);

  final RxList<History> histories = <History>[].obs;
  final RxBool isLoading = false.obs;

  // final RxList<History> displayedHistory = <History>[].obs;

  Future<void> loadAllHistories({bool refresh = false}) async {
    if (refresh) {
      histories.clear();
    }

    isLoading.value = true;
    try {
      final historyList = await _repository.getListAllHistory();
      if (historyList != null) {
        histories.assignAll(historyList);
        print("Loaded ${historyList.length} histories");
      } else {
        histories.clear();
        print("no histories found");
      }
    } catch (e) {
      print("error load histories(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
