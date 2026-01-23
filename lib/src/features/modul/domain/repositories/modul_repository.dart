import 'dart:io';

import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';

abstract class ModulRepository {
  Future<List<Modul>?>? getListModul();
  Future<Modul?> getModul(String id);
  Future<Modul?> addModulToUSer(String serialId, String password);
  Future<Modul?> editModul(
    String serialId, {
    String? name,
    String? password,
    String? description,
    File? imageFile,
  });

  Future<void> deleteModulFromUser(String serialId);
  Future<void> deleteLocalModul(String serialId);
}
