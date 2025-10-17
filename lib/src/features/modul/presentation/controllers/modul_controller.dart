import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/application/services/modul_services.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';

class ModulController extends GetxController {
  final ModulServices _modulServices = Get.find<ModulServices>();

  RxBool get isLoading => _modulServices.isLoading;
  RxList<Modul> get devices => _modulServices.devices;
  Rx<Modul?> get selectedDevice => _modulServices.selectedDevice;

  Future<void> refreshModulList() async {
    await _modulServices.loadDevices(refresh: true);
  }

  Future<void> getSelectedDevice(String id) async {
    await _modulServices.loadDevice(id);
  }
}
