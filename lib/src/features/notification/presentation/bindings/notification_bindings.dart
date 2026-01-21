import 'package:get/get.dart';
import 'package:pak_tani/src/core/services/api_service.dart';
import 'package:pak_tani/src/features/notification/application/services/notification_service.dart';
import 'package:pak_tani/src/features/notification/data/datasources/notification_remote_datasource_impl.dart';
import 'package:pak_tani/src/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:pak_tani/src/features/notification/domain/datasources/notification_remote_datasource.dart';
import 'package:pak_tani/src/features/notification/domain/repositories/notification_repository.dart';
import 'package:pak_tani/src/features/notification/presentation/controllers/notification_screen_controller.dart';

class NotificationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationRemoteDatasource>(
      () => NotificationRemoteDatasourceImpl(Get.find<ApiService>()),
      fenix: true,
    );

    Get.lazyPut<NotificationRepository>(
      () =>
          NotificationRepositoryImpl(Get.find<NotificationRemoteDatasource>()),
      fenix: true,
    );

    Get.lazyPut<NotificationService>(
      () => NotificationService(Get.find<NotificationRepository>()),
      fenix: true,
    );

    Get.lazyPut<NotificationScreenController>(
      () => NotificationScreenController(Get.find<NotificationService>()),
      fenix: true,
    );
  }
}
