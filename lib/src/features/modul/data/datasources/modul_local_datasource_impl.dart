import 'package:hive/hive.dart';
import 'package:pak_tani/src/core/utils/log_utils.dart';
import 'package:pak_tani/src/features/modul/domain/datasources/modul_local_datasource.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';

class ModulLocalDatasourceImpl implements ModulLocalDatasource {
  late Box<Modul> _modulBox;

  ModulLocalDatasourceImpl() {
    _initHive();
  }

  Future<void> _initHive() async {
    _modulBox = await Hive.openBox<Modul>("modulBox");
  }

  /// save list of modul to hive
  @override
  Future<void> saveModuls(List<Modul> moduls) async {
    for (var modul in moduls) {
      await _modulBox.put(modul.serialId, modul);
    }
  }

  /// get all modul from hive
  @override
  List<Modul> getModuls() {
    return _modulBox.values.toList();
  }

  /// merge local modul
  @override
  List<Modul> mergeModuls(List<Modul> remoteModuls) {
    final localModuls = getModuls();
    LogUtils.d("local modul: ${remoteModuls.map((e) => e.id)}");
    final merged = <Modul>[];

    merged.addAll(remoteModuls);

    for (var local in localModuls) {
      if (!remoteModuls.any((element) => element.serialId == local.serialId)) {
        final lockedModul = Modul(
          id: local.id,
          name: local.name,
          descriptions: local.descriptions,
          serialId: local.serialId,
          features: local.features,
          createdAt: local.createdAt,
          image: local.image,
          isLocked: true,
        );
        merged.add(lockedModul);
      }
    }
    return merged;
  }

  /// Delete modul by serialId from hive
  @override
  Future<void> deleteModul(String serialId) async {
    await _modulBox.delete(serialId);
  }

  @override
  Future<void> clearModuls() async {
    await _modulBox.clear();
  }

  /// Close hive box
  @override
  Future<void> closeBox() async {
    await _modulBox.close();
  }
}
