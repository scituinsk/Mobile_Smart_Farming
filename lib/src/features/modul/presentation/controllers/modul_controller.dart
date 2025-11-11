import 'dart:io';

import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_services.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';

class ModulController extends GetxController {
  final ModulServices _modulServices = Get.find<ModulServices>();

  RxBool get isLoadingModul => _modulServices.isLoading;

  RxList<Modul> get devices => _modulServices.moduls;
  Rx<Modul?> get selectedDevice => _modulServices.selectedModul;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _modulServices.loadModuls();
  }

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

  Future<void> editModul(
    String id, {
    String? name,
    String? description,
    File? imageFile,
  }) async {
    try {
      await _modulServices.editModul(
        id,
        name: name,
        description: description,
        imageFile: imageFile,
      );
    } catch (e) {
      print("error(controller): $e");
      rethrow;
    }
  }

  Future<void> editPasswordModul(String id, {String? password}) async {
    try {
      await _modulServices.editModul(id, password: password);
    } catch (e) {
      print("error(controller): $e");
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
