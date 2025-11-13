import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/relay_services.dart';
import 'package:pak_tani/src/features/modul/data/datasource/relay_remote_datasource.dart';
import 'package:pak_tani/src/features/modul/data/repositories/relay_repository_impl.dart';
import 'package:pak_tani/src/features/modul/domain/repositories/relay_repository.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_controller.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/relay_controller.dart';

class RelayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RelayRemoteDatasource>(
      () => RelayRemoteDatasourceImpl(),
      fenix: true,
    );

    Get.lazyPut<RelayRepository>(
      () => RelayRepositoryImpl(
        remoteDatasource: Get.find<RelayRemoteDatasource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<RelayServices>(
      () => RelayServices(Get.find<RelayRepository>()),
      fenix: true,
    );

    Get.put<RelayController>(
      RelayController(Get.find<RelayServices>(), Get.find<ModulController>()),
    );

    print('✅ ModulBinding dependencies initialized');
  }
}
