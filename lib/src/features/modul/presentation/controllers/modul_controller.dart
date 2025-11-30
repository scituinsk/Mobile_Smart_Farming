import 'package:get/get.dart';
import 'package:pak_tani/src/core/widgets/my_snackbar.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_service.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';

class ModulController extends GetxController {
  final ModulService _modulServices;
  ModulController(this._modulServices);

  RxBool get isLoadingModul => _modulServices.isLoading;

  RxList<Modul> get devices => _modulServices.moduls;

  Future<void> refreshModulList() async {
    try {
      await _modulServices.loadModuls(refresh: true);
    } catch (e) {
      print("error: $e");
      MySnackbar.error(message: e.toString());
    }
  }
}
