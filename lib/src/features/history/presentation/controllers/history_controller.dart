import 'package:get/get.dart';
import 'package:pak_tani/src/core/widgets/my_snackbar.dart';
import 'package:pak_tani/src/features/history/application/services/history_service.dart';
import 'package:pak_tani/src/features/history/domain/entities/history.dart';

class HistoryController extends GetxController {
  final HistoryService historyService;
  HistoryController(this.historyService);

  RxList<History> get histories => historyService.histories;

  RxBool get isLoading => historyService.isLoading;

  Future<void> refreshHistoryList() async {
    try {
      await historyService.loadAllHistories(refresh: true);
    } catch (e) {
      print("error: $e");
      MySnackbar.error(message: e.toString());
    }
  }
}
