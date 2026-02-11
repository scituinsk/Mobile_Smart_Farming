import 'dart:io';

import 'package:pak_tani/src/core/utils/log_utils.dart';
import 'package:pak_tani/src/features/modul/domain/datasources/modul_local_datasource.dart';
import 'package:pak_tani/src/features/modul/domain/datasources/modul_remote_datasource.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:pak_tani/src/features/modul/domain/repositories/modul_repository.dart';

class ModulRepositoryImpl implements ModulRepository {
  final ModulRemoteDatasource remoteDatasource;
  final ModulLocalDatasource localDatasource;

  ModulRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<Modul>?>? getListModul() async {
    try {
      final listModul = await remoteDatasource.getListModuls();

      if (listModul != null) {
        final entities = listModul.map((modul) => modul.toEntity()).toList();
        await localDatasource.saveModuls(entities);
        return localDatasource.mergeModuls(entities);
      }
      return localDatasource.mergeModuls([]);
    } catch (e) {
      LogUtils.e("error get list modul(repository)", e);
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
      LogUtils.e("error get modul(repository)", e);
      rethrow;
    }
  }

  @override
  Future<Modul?> addModulToUSer(String serialId, String password) async {
    try {
      final modul = await remoteDatasource.addModulToUser(serialId, password);
      if (modul == null) {
        return null;
      }
      return modul.toEntity();
    } catch (e) {
      LogUtils.e("error add modul(repository)", e);
      rethrow;
    }
  }

  @override
  Future<Modul?> editModul(
    String serialId, {
    String? name,
    String? password,
    String? description,
    File? imageFile,
  }) async {
    try {
      final modul = await remoteDatasource.editModul(
        serialId,
        name: name,
        description: description,
        imageFile: imageFile,
        password: password,
      );
      if (modul == null) return null;
      return modul.toEntity();
    } catch (e) {
      LogUtils.e("error edit modul(repository)", e);
      rethrow;
    }
  }

  @override
  Future<void> deleteModulFromUser(String serialId) async {
    try {
      await remoteDatasource.deleteModulFromUser(serialId);
      await localDatasource.deleteModul(serialId);
    } catch (e) {
      LogUtils.e("error deleting modul(repository)", e);
      rethrow;
    }
  }

  @override
  Future<void> deleteLocalModul(String serialId) async {
    try {
      await localDatasource.deleteModul(serialId);
    } catch (e) {
      LogUtils.e("Error deleting local modul(repository)", e);
      rethrow;
    }
  }

  @override
  Future<void> clearLocalModul() async {
    try {
      await localDatasource.clearModuls();
    } catch (e) {
      rethrow;
    }
  }
}
