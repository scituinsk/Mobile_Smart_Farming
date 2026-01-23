// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modul_feature.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModulFeatureAdapter extends TypeAdapter<ModulFeature> {
  @override
  final int typeId = 1;

  @override
  ModulFeature read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModulFeature(
      name: fields[0] as String,
      descriptions: fields[1] as String?,
      data: (fields[2] as List?)?.cast<FeatureData>(),
    );
  }

  @override
  void write(BinaryWriter writer, ModulFeature obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.descriptions)
      ..writeByte(2)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModulFeatureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
