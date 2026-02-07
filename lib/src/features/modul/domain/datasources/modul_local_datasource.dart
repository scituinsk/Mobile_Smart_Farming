import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';

abstract class ModulLocalDatasource {
  Future<void> saveModuls(List<Modul> moduls);
  List<Modul> getModuls();
  List<Modul> mergeModuls(List<Modul> remoteModuls);
  Future<void> deleteModul(String serialId);
  Future<void> closeBox();
  Future<void> clearModuls();
}
