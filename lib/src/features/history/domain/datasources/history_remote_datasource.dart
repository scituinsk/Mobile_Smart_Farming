import 'package:pak_tani/src/features/history/data/models/history_model.dart';

abstract class HistoryRemoteDatasource {
  Future<List<HistoryModel>?> getListAllHistory();
  Future<List<HistoryModel>?> getListHistory(String modulId);
}
