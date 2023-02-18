// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datas_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DatasAdapter extends TypeAdapter<Datas> {
  @override
  final int typeId = 4;

  @override
  Datas read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Datas(
      id: fields[0] as int?,
      zapros: fields[1] as String?,
      rezult: fields[2] as String?,
      platforma: fields[3] as String?,
      tel: fields[4] as String?,
      flag: fields[5] as int?,
      sana: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Datas obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.zapros)
      ..writeByte(2)
      ..write(obj.rezult)
      ..writeByte(3)
      ..write(obj.platforma)
      ..writeByte(4)
      ..write(obj.tel)
      ..writeByte(5)
      ..write(obj.flag)
      ..writeByte(6)
      ..write(obj.sana);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatasAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

