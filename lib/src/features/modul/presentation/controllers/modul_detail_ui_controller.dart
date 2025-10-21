import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/core/services/web_socket_service.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul_data.dart';
import 'package:pak_tani/src/features/modul/presentation/controllers/modul_controller.dart';

class ModulDetailUiController extends GetxController {
  final _controller = Get.find<ModulController>();
  Rx<Modul?> get modul => _controller.selectedDevice;
  final RxBool isLoading = false.obs;

  late String modulId;

  final _ws = Rxn<DeviceWsHandle>();
  StreamSubscription? _sub;

  final _storage = Get.find<StorageService>();
  final _wsService = Get.find<WebSocketService>();

  final Rxn<ModulData> modulData = Rxn<ModulData>();

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading.value = true;
    try {
      modulId = await Get.arguments;
      await getDevice(modulId);
      print("selected device: ${modul.value!.name}");

      final token = await _storage.readSecure("access_token");
      if (token == null || token.isEmpty) {
        print("token tidak ditemukan");
        return;
      }

      final handle = await _wsService.openDeviceStream(
        token: token,
        modulId: modulId,
      );
      _ws.value = handle;

      _sub = handle.stream.listen(
        (raw) {
          try {
            final json = jsonDecode(raw as String) as Map<String, dynamic>;
            final data = ModulData.fromJson(json);
            modulData.value = data;

            print(
              "T=${data.temperature}, H=${data.humidity}, B=${data.battery}, W=${data.waterLevel}",
            );
          } catch (e) {
            print("parse error: $e | raw=$raw");
          }
        },
        onError: (e) => print('WS error: $e'),
        onDone: () => print('WS selesai'),
        cancelOnError: false,
      );

      _ws.value?.send("STREAMING_ON");
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

  @override
  Future<void> onClose() async {
    _ws.value?.send("STREAMING_OFF");
    await _sub?.cancel();
    await _ws.value?.close(); // berhenti streaming saat dispose
    super.onClose();
  }
}
