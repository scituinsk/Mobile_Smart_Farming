import 'package:pak_tani/src/features/modul/data/datasource/modul_remote_datasource.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/domain/repositories/modul_repository.dart';

class ModulRepositoryImpl implements ModulRepository {
  final ModulRemoteDatasource remoteDatasource;

  ModulRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<Modul>?>? getListDevices() async {
    // TODO: implement getListDevices
    try {
      final listModul = await remoteDatasource.getListDevices();

      if (listModul != null) {
        return listModul.map((modul) => modul.toEntity()).toList();
      }
      return null;
    } catch (e) {
      print("error get list modul(repository): $e");
      rethrow;
    }
  }

  @override
  Future<Modul?> getDevice(String id) {
    // TODO: implement getDevice
    throw UnimplementedError();
  }

  @override
  Future<Modul> editDevice(
    String id, {
    String? name,
    String? description,
    String? imagePath,
  }) {
    // TODO: implement editDevice
    throw UnimplementedError();
  }

  @override
  Future<void> deleteDeviceFromUser(String id) {
    // TODO: implement deleteDeviceFromUser
    throw UnimplementedError();
  }

  @override
  Future<String> scanQr() {
    // TODO: implement scanQr
    throw UnimplementedError();
  }
}
