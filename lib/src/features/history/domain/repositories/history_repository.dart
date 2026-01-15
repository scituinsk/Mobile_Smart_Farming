import 'package:pak_tani/src/features/history/domain/entities/history.dart';

abstract class HistoryRepository {
  Future<List<History>?> getListAllHistory();
  Future<List<History>?> getListHistory(String modulId);
}
