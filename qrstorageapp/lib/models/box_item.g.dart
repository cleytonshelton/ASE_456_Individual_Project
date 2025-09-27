// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoxItemAdapter extends TypeAdapter<BoxItem> {
  @override
  final int typeId = 0;

  @override
  BoxItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoxItem(
      qr: fields[0] as String,
      description: fields[1] as String,
      imagePaths: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, BoxItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.qr)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.imagePaths);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoxItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
