import 'package:dio/dio.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/features/history/data/models/history_model.dart';
import 'package:pak_tani/src/features/history/domain/datasources/history_remote_datasource.dart';

class HistoryRemoteDatasourceImpl extends HistoryRemoteDatasource {
  final ApiService _apiService;
  HistoryRemoteDatasourceImpl(this._apiService);

  @override
  Future<List<HistoryModel>?> getListAllHistory() async {
    final Response response = await _apiService.get("/iot/device/logs/");
    final responseData = response.data["data"] as List<dynamic>;

    return responseData
        .map((json) => HistoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<HistoryModel>?> getListHistory(String modulId) async {
    final Response response = await _apiService.get(
      "/iot/device/$modulId/logs/",
    );
    final responseData = response.data["data"] as List<dynamic>;

    return responseData
        .map((json) => HistoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
