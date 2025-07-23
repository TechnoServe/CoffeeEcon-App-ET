// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SiteInfoAdapter extends TypeAdapter<SiteInfo> {
  @override
  final int typeId = 2;

  @override
  SiteInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SiteInfo(
      siteName: fields[1] as String,
      location: fields[2] as String,
      businessModel: fields[3] as String,
      processingCapacity: fields[4] as int,
      storageSpace: fields[5] as int,
      dryingBeds: fields[6] as int,
      fermentationTanks: fields[7] as int,
      pulpingCapacity: fields[8] as int,
      workers: fields[9] as int,
      farmers: fields[10] as int,
      id: fields[0] as String?,
      createdAt: fields[12] as DateTime?,
      deletedAt: fields[13] as DateTime?,
      updatedAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SiteInfo obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.siteName)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.businessModel)
      ..writeByte(4)
      ..write(obj.processingCapacity)
      ..writeByte(5)
      ..write(obj.storageSpace)
      ..writeByte(6)
      ..write(obj.dryingBeds)
      ..writeByte(7)
      ..write(obj.fermentationTanks)
      ..writeByte(8)
      ..write(obj.pulpingCapacity)
      ..writeByte(9)
      ..write(obj.workers)
      ..writeByte(10)
      ..write(obj.farmers)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.deletedAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SiteInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
