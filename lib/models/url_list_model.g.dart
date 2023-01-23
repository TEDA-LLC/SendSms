// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UrllListAdapter extends TypeAdapter<UrllList> {
  @override
  final int typeId = 0;

  @override
  UrllList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UrllList()..url = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, UrllList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UrllListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
