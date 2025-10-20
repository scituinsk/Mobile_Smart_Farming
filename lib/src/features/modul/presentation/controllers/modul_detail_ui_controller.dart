import 'package:get/get.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_controller.dart';

class ModulDetailUiController extends GetxController {
  final _controller = Get.find<ModulController>();
  Rx<Modul?> get modul => _controller.selectedDevice;
  final RxBool isLoading = false.obs;

  late String modulId;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    try {
      modulId = await Get.arguments;
      await getDevice(modulId);
      print("selected device: ${modul.value!.name}");
    } catch (e) {
      print("error at detail init: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getDevice(String id) async {
    await _controller.getSelectedModul(id);
  }

  Future<void> deleteDevice() async {
    try {
      await _controller.deleteModul(modul.value!.serialId);
      Get.back();
      Get.snackbar("success", "berhasil menghapus modul dari user ini");
    } catch (e) {
      print("error (ui controller): $e");
      Get.snackbar("Error!", e.toString());
    }
  }
}
