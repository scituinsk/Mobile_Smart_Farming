import 'dart:io';

import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/domain/repositories/modul_repository.dart';

class ModulService extends GetxService {
  final ModulRepository _repository = Get.find<ModulRepository>();

  final RxBool isLoading = false.obs;

  final RxList<Modul> moduls = <Modul>[].obs;
  final Rx<Modul?> selectedModul = Rx<Modul?>(null);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadModuls();
  }

  Future<void> loadModuls({bool refresh = false}) async {
    if (refresh) {
      moduls.clear();
    }

    isLoading.value = true;
    print("memulai loading: ${isLoading.value}");

    try {
      print("loading devices.....");
      final deviceList = await _repository.getListModul();

      if (deviceList != null) {
        moduls.assignAll(deviceList);
        print("loaded ${deviceList.length} devices");
      } else {
        moduls.clear();
        print("no device found");
      }
    } catch (e) {
      print("error loading devices(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadModul(String id) async {
    isLoading.value = true;

    try {
      print("loading get device");
      final modul = await _repository.getModul(id);
      if (modul != null) {
        final index = moduls.indexWhere((d) => d.serialId == modul.serialId);
        if (index != -1) {
          moduls[index] = modul;
        } else {
          moduls.add(modul);
        }
        selectedModul.value = modul;
      }
    } catch (e) {
      print("error load device(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addModul(String id, String password) async {
    isLoading.value = true;

    try {
      final modul = await _repository.addModulToUSer(id, password);
      if (modul != null) {
        final index = moduls.indexWhere(
          (device) => device.serialId == modul.serialId,
        );
        if (index != -1) {
          moduls[index] = modul;
        } else {
          moduls.add(modul);
        }
      }
    } catch (e) {
      print("error add device(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editModul(
    String id, {
    String? name,
    String? password,
    String? description,
    File? imageFile,
  }) async {
    isLoading.value = true;
    try {
      final modul = await _repository.editModul(
        id,
        name: name,
        description: description,
        imageFile: imageFile,
        password: password,
      );
      if (modul != null) {
        final index = moduls.indexWhere(
          (element) => element.serialId == modul.serialId,
        );
        moduls[index] = modul;
      }
    } catch (e) {
      print("error editing modul(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteModul(String id) async {
    isLoading.value = true;
    try {
      await _repository.deleteModulFromUser(id);
      moduls.removeWhere((element) => element.serialId == id);
    } catch (e) {
      print("error removing modul: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
