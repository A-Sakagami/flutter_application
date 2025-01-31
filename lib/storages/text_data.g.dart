// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TextDataAdapter extends TypeAdapter<TextData> {
  @override
  final int typeId = 1;

  @override
  TextData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextData(
      text: fields[0] as String?,
      approved: fields[1] as bool?,
      denyed: fields[2] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, TextData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.approved)
      ..writeByte(2)
      ..write(obj.denyed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
