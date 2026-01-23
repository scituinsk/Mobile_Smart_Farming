// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeatureDataAdapter extends TypeAdapter<FeatureData> {
  @override
  final int typeId = 2;

  @override
  FeatureData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeatureData(
      name: fields[0] as String,
      data: fields[1] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, FeatureData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeatureDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
