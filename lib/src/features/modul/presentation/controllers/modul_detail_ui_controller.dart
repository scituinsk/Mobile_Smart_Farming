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
    await _controller.getSelectedDevice(id);
  }
}
