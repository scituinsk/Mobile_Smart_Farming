import 'dart:io';

import 'package:pak_tani/src/features/modul/data/models/modul_model.dart';

abstract class ModulRemoteDatasource {
  Future<List<ModulModel>?> getListModuls();
  Future<ModulModel?> getModul(String id);
  Future<ModulModel?> editModul(
    String id, {
    String? name,
    String? password,
    String? description,
    File? imageFile,
  });
  Future<void> deleteModulFromUser(String id);
  Future<ModulModel?> addModulToUser(String id, String password);
}
