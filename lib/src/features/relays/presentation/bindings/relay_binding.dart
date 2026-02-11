import 'package:get/get.dart';
import 'package:pak_tani/src/core/utils/log_utils.dart';
import 'package:pak_tani/src/features/relays/application/services/relay_service.dart';
import 'package:pak_tani/src/features/relays/data/datasources/relay_remote_datasource_impl.dart';
import 'package:pak_tani/src/features/relays/data/repositories/relay_repository_impl.dart';
import 'package:pak_tani/src/features/relays/domain/datasources/relay_remote_datasource.dart';
import 'package:pak_tani/src/features/relays/domain/repositories/relay_repository.dart';

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

    LogUtils.d('✅ RelayBinding dependencies initialized');
  }
}
