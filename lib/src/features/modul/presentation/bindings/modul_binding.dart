import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_service.dart';
import 'package:pak_tani/src/features/modul/data/datasources/modul_local_datasource_impl.dart';
import 'package:pak_tani/src/features/modul/data/datasources/modul_remote_datasource_impl.dart';
import 'package:pak_tani/src/features/modul/data/repositories/modul_repository_impl.dart';
import 'package:pak_tani/src/features/modul/domain/datasources/modul_local_datasource.dart';
import 'package:pak_tani/src/features/modul/domain/datasources/modul_remote_datasource.dart';
import 'package:pak_tani/src/features/modul/domain/repositories/modul_repository.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_controller.dart';

class ModulBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModulLocalDatasource>(
      () => ModulLocalDatasourceImpl(),
      fenix: true,
    );

    Get.lazyPut<ModulRemoteDatasource>(
      () => ModulRemoteDatasourceImpl(),
      fenix: true,
    );

    Get.lazyPut<ModulRepository>(
      () => ModulRepositoryImpl(
        remoteDatasource: Get.find<ModulRemoteDatasource>(),
        localDatasource: Get.find<ModulLocalDatasource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ModulService>(
      () => ModulService(Get.find<ModulRepository>()),
      fenix: true,
    );

    Get.lazyPut<ModulController>(
      () => ModulController(Get.find<ModulService>()),
      fenix: true,
    );

    print('✅ ModulBinding dependencies initialized');
  }
}
