import 'package:pak_tani/src/core/utils/log_utils.dart';
import 'package:pak_tani/src/features/history/domain/datasources/history_remote_datasource.dart';
import 'package:pak_tani/src/features/history/domain/entities/history.dart';
import 'package:pak_tani/src/features/history/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl extends HistoryRepository {
  final HistoryRemoteDatasource _remoteDatasource;

  HistoryRepositoryImpl(this._remoteDatasource);

  @override
  Future<List<History>?> getListAllHistory() async {
    try {
      final listHistory = await _remoteDatasource.getListAllHistory();
      if (listHistory != null) {
        return listHistory.map((history) => history.toEntity()).toList();
      }
      return null;
    } catch (e) {
      LogUtils.e("Error get list all history(repo)", e);
      rethrow;
    }
  }

  @override
  Future<List<History>?> getListHistory(String modulId) async {
    try {
      final listHistory = await _remoteDatasource.getListHistory(modulId);
      if (listHistory != null) {
        return listHistory.map((history) => history.toEntity()).toList();
      }
      return null;
    } catch (e) {
      LogUtils.e("Error get list history(repo)", e);
      rethrow;
    }
  }
}
