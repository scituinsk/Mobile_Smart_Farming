import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_services.dart';
import 'package:pak_tani/src/features/modul/data/datasource/modul_remote_datasource.dart';
import 'package:pak_tani/src/features/modul/data/repositories/modul_repository_impl.dart';
import 'package:pak_tani/src/features/modul/domain/repositories/modul_repository.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_controller.dart';

class ModulBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModulRemoteDatasource>(
      () => ModulRemoteDatasourceImpl(),
      fenix: true,
    );

    Get.lazyPut<ModulRepository>(
      () => ModulRepositoryImpl(
        remoteDatasource: Get.find<ModulRemoteDatasource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ModulServices>(() => ModulServices(), fenix: true);

    Get.lazyPut<ModulController>(() => ModulController(), fenix: true);

    print('✅ ModulBinding dependencies initialized');
  }
}
