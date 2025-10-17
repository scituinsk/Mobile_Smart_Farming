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
      final listModul = await remoteDatasource.getListModuls();

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
  Future<Modul?> getDevice(String id) async {
    try {
      final modul = await remoteDatasource.getModul(id);
      if (modul == null) {
        return null;
      }
      return modul.toEntity();
    } catch (e) {
      print("error get modul(repository): $e");
      rethrow;
    }
  }

  @override
  Future<Modul> editDevice(
    String id, {
    String? name,
    String? password,
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
}
