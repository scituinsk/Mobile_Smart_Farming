import 'package:get/get.dart';
import 'package:pak_tani/src/core/utils/log_utils.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_service.dart';
import 'package:pak_tani/src/features/modul/domain/repositories/modul_repository.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_controller.dart';

class ModulBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModulService>(
      () => ModulService(Get.find<ModulRepository>()),
      fenix: true,
    );

    Get.lazyPut<ModulController>(
      () => ModulController(Get.find<ModulService>()),
      fenix: true,
    );

    LogUtils.d('✅ ModulBinding dependencies initialized');
  }
}
