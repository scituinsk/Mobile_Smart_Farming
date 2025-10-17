import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/domain/repositories/modul_repository.dart';

class ModulServices extends GetxService {
  final ModulRepository _repository = Get.find<ModulRepository>();

  final RxBool isLoading = false.obs;
  final RxList<Modul> devices = <Modul>[].obs;
  final Rx<Modul?> selectedDevice = Rx<Modul?>(null);

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await loadDevices();
  }

  Future<void> loadDevices({bool refresh = false}) async {
    if (refresh) {
      devices.clear();
    }

    isLoading.value = true;

    try {
      print("loading devices.....");
      final deviceList = await _repository.getListDevices();

      if (deviceList != null) {
        devices.assignAll(deviceList);
        print("loaded ${deviceList.length} devices");
      } else {
        devices.clear();
        print("no device found");
      }
    } catch (e) {
      print("error loading devices(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadDevice(String id) async {
    isLoading.value = true;

    try {
      print("loading get device");
      final device = await _repository.getDevice(id);
      if (device != null) {
        final index = devices.indexWhere((d) => d.serialId == device.serialId);
        if (index != -1) {
          devices[index] = device;
        } else {
          devices.add(device);
        }
        selectedDevice.value = device;
      }
    } catch (e) {
      print("error load device(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
