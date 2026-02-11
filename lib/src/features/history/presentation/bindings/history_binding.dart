import 'package:get/get.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/core/utils/log_utils.dart';
import 'package:pak_tani/src/features/history/application/services/history_service.dart';
import 'package:pak_tani/src/features/history/data/datasources/history_remote_datasource_impl.dart';
import 'package:pak_tani/src/features/history/data/repositories/history_repository_impl.dart';
import 'package:pak_tani/src/features/history/domain/datasources/history_remote_datasource.dart';
import 'package:pak_tani/src/features/history/domain/repositories/history_repository.dart';
import 'package:pak_tani/src/features/history/presentation/controllers/history_controller.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_service.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryRemoteDatasource>(
      () => HistoryRemoteDatasourceImpl(Get.find<ApiService>()),
      fenix: true,
    );

    Get.lazyPut<HistoryRepository>(
      () => HistoryRepositoryImpl(Get.find<HistoryRemoteDatasource>()),
      fenix: true,
    );

    Get.lazyPut<HistoryService>(
      () => HistoryService(Get.find<HistoryRepository>()),
      fenix: true,
    );

    Get.lazyPut<HistoryController>(
      () => HistoryController(
        Get.find<HistoryService>(),
        Get.find<ModulService>(),
      ),
      fenix: true,
    );

    LogUtils.d("✅ history binding dependecies initialized");
  }
}
