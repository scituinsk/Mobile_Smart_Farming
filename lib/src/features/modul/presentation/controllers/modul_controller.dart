import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_services.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';

class ModulController extends GetxController {
  final ModulServices _modulServices = Get.find<ModulServices>();

  RxBool get isLoading => _modulServices.isLoading;
  RxList<Modul> get devices => _modulServices.moduls;
  Rx<Modul?> get selectedDevice => _modulServices.selectedModul;

  Future<void> refreshModulList() async {
    try {
      await _modulServices.loadModuls(refresh: true);
    } catch (e) {
      print("error: $e");
      Get.snackbar("Error!", e.toString());
    }
  }

  Future<void> getSelectedModul(String id) async {
    try {
      await _modulServices.loadModul(id);
    } catch (e) {
      print('error: $e');
      Get.snackbar("Error!", e.toString());
    }
  }

  Future<void> addModul(String id, String password) async {
    try {
      await _modulServices.addModul(id, password);
    } catch (e) {
      print('error(controller): $e');
      rethrow;
    }
  }

  Future<void> deleteModul(String id) async {
    try {
      await _modulServices.deleteModul(id);
    } catch (e) {
      print('error(controller): $e');
      rethrow;
    }
  }
}
