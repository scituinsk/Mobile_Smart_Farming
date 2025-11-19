import 'package:get/get.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/features/group_schedule/application/services/schedule_service.dart';
import 'package:pak_tani/src/features/group_schedule/data/datasources/schedule_remote_datasource_impl.dart';
import 'package:pak_tani/src/features/group_schedule/data/repositories/schedule_repository_impl.dart';
import 'package:pak_tani/src/features/group_schedule/domain/datasources/schedule_remote_datasource.dart';
import 'package:pak_tani/src/features/group_schedule/domain/repositories/schedule_repository.dart';
import 'package:pak_tani/src/features/group_schedule/presentation/controllers/group_schedule_ui_controller.dart';
import 'package:pak_tani/src/features/modul/application/services/relay_service.dart';

class GroupScheduleScreenBinding extends Bindings {
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
      GroupScheduleUiController(
        Get.find<RelayService>(),
        Get.find<ScheduleService>(),
      ),
    );
  }
}
