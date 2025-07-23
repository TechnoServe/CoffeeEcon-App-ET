// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_breakdown_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedBreakdownModelAdapter extends TypeAdapter<SavedBreakdownModel> {
  @override
  final int typeId = 10;

  @override
  SavedBreakdownModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedBreakdownModel(
      title: fields[7] as String,
      selectedSites: (fields[8] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      isBestPractice: fields[12] as bool,
      type: fields[1] as ResultsOverviewType,
      basicCalculation: fields[2] as BasicCalculationEntryModel?,
      advancedCalculation: fields[3] as AdvancedCalculationModel?,
      breakEvenPrice: fields[4] as double?,
      cherryPrice: fields[5] as double?,
      id: fields[0] as String?,
      createdAt: fields[9] as DateTime?,
      deletedAt: fields[10] as DateTime?,
      updatedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SavedBreakdownModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.basicCalculation)
      ..writeByte(3)
      ..write(obj.advancedCalculation)
      ..writeByte(4)
      ..write(obj.breakEvenPrice)
      ..writeByte(5)
      ..write(obj.cherryPrice)
      ..writeByte(7)
      ..write(obj.title)
      ..writeByte(8)
      ..write(obj.selectedSites)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.deletedAt)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(12)
      ..write(obj.isBestPractice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedBreakdownModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
