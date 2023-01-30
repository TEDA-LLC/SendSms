// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SmsModelAdapter extends TypeAdapter<SmsModel> {
  @override
  final int typeId = 2;

  @override
  SmsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SmsModel(
      message: fields[0] as String?,
      success: fields[1] as bool?,
      status: fields[2] as int?,
      data: (fields[3] as List?)?.cast<Datas>(),
    );
  }

  @override
  void write(BinaryWriter writer, SmsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.message)
      ..writeByte(1)
      ..write(obj.success)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DatasAdapter extends TypeAdapter<Datas> {
  @override
  final int typeId = 3;

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
