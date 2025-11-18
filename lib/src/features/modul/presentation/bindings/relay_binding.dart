import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/relay_service.dart';
import 'package:pak_tani/src/features/modul/data/datasource/relay_remote_datasource_impl.dart';
import 'package:pak_tani/src/features/modul/data/repositories/relay_repository_impl.dart';
import 'package:pak_tani/src/features/modul/domain/datasources/relay_remote_datasource.dart';
import 'package:pak_tani/src/features/modul/domain/repositories/relay_repository.dart';

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

    Get.lazyPut<RelayService>(
      () => RelayService(Get.find<RelayRepository>()),
      fenix: true,
    );

    print('✅ ModulBinding dependencies initialized');
  }
}
