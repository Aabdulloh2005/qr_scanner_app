// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_code.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QrCodeModelAdapter extends TypeAdapter<QrCodeModel> {
  @override
  final int typeId = 0;

  @override
  QrCodeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QrCodeModel(
      content: fields[0] as String,
      createdAt: fields[1] as DateTime,
      isScanned: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, QrCodeModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.isScanned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QrCodeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
