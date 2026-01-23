// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modul.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModulAdapter extends TypeAdapter<Modul> {
  @override
  final int typeId = 0;

  @override
  Modul read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Modul(
      id: fields[0] as String,
      name: fields[1] as String,
      descriptions: fields[2] as String?,
      serialId: fields[3] as String,
      features: (fields[4] as List?)?.cast<ModulFeature>(),
      createdAt: fields[5] as String,
      image: fields[6] as String?,
      isLocked: fields[7] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Modul obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.descriptions)
      ..writeByte(3)
      ..write(obj.serialId)
      ..writeByte(4)
      ..write(obj.features)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.image)
      ..writeByte(7)
      ..write(obj.isLocked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModulAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
