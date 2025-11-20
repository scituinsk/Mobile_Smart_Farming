import 'package:get/get.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/features/schedule/application/services/schedule_service.dart';
import 'package:pak_tani/src/features/schedule/data/datasources/schedule_remote_datasource_impl.dart';
import 'package:pak_tani/src/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:pak_tani/src/features/schedule/domain/datasources/schedule_remote_datasource.dart';
import 'package:pak_tani/src/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:pak_tani/src/features/schedule/presentation/controllers/schedule_ui_controller.dart';
import 'package:pak_tani/src/features/relays/application/services/relay_service.dart';

class ScheduleScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleRemoteDatasource>(
      () => ScheduleRemoteDatasourceImpl(Get.find<ApiService>()),
      fenix: true,
    );
    Get.lazyPut<ScheduleRepository>(
      () => ScheduleRepositoryImpl(Get.find<ScheduleRemoteDatasource>()),
      fenix: true,
    );
    Get.put(ScheduleService(Get.find<ScheduleRepository>()));
    Get.put(
      ScheduleUiController(
        Get.find<RelayService>(),
        Get.find<ScheduleService>(),
      ),
    );
  }
}
