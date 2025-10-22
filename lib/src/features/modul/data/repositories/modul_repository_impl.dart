import 'dart:io';

import 'package:pak_tani/src/features/modul/data/datasource/modul_remote_datasource.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/domain/repositories/modul_repository.dart';

class ModulRepositoryImpl implements ModulRepository {
  final ModulRemoteDatasource remoteDatasource;

  ModulRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<Modul>?>? getListModul() async {
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
  Future<Modul?> getModul(String id) async {
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
  Future<Modul?> addModulToUSer(String id, String password) async {
    try {
      final modul = await remoteDatasource.addModulToUser(id, password);
      if (modul == null) {
        return null;
      }
      return modul.toEntity();
    } catch (e) {
      print("error add modul(repository): $e");
      rethrow;
    }
  }

  @override
  Future<Modul?> editModul(
    String id, {
    String? name,
    String? password,
    String? description,
    File? imageFile,
  }) async {
    try {
      final modul = await remoteDatasource.editModul(
        id,
        name: name,
        description: description,
        imageFile: imageFile,
        password: password,
      );
      if (modul == null) return null;
      return modul.toEntity();
    } catch (e) {
      print("error edit modul(repository): $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteModulFromUser(String id) async {
    try {
      await remoteDatasource.deleteModulFromUser(id);
    } catch (e) {
      print("error deleting modul(repository): $e");
      rethrow;
    }
  }
}
