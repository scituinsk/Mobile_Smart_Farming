import 'dart:io';

import 'package:pak_tani/src/features/modul/data/models/modul_model.dart';

abstract class ModulRemoteDatasource {
  Future<List<ModulModel>?> getListModuls();
  Future<ModulModel?> getModul(String serialId);
  Future<ModulModel?> editModul(
    String serialId, {
    String? name,
    String? password,
    String? description,
    File? imageFile,
  });
  Future<void> deleteModulFromUser(String serialId);
  Future<ModulModel?> addModulToUser(String serialId, String password);
}
