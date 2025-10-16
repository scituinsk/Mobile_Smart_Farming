import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';

abstract class ModulRepository {
  Future<List<Modul>?>? getListDevices();
  Future<Modul?> getDevice(String id);
  Future<Modul> editDevice(
    String id, {
    String? name,
    String? description,
    String? imagePath,
  });
  Future<void> deleteDeviceFromUser(String id);
  Future<String> scanQr();
}
