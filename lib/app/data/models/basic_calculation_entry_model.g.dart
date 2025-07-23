// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_calculation_entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BasicCalculationEntryModelAdapter
    extends TypeAdapter<BasicCalculationEntryModel> {
  @override
  final int typeId = 11;

  @override
  BasicCalculationEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BasicCalculationEntryModel(
      totalSellingPrice: fields[11] as double,
      purchaseVolume: fields[0] as String,
      seasonalPrice: fields[1] as String,
      fuelAndOils: fields[2] as String,
      cherryTransport: fields[3] as String,
      laborFullTime: fields[4] as String,
      laborCasual: fields[5] as String,
      repairsAndMaintenance: fields[6] as String,
      otherExpenses: fields[7] as String,
      ratio: fields[8] as String,
      expectedProfit: fields[9] as String,
      sellingType: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BasicCalculationEntryModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.purchaseVolume)
      ..writeByte(1)
      ..write(obj.seasonalPrice)
      ..writeByte(2)
      ..write(obj.fuelAndOils)
      ..writeByte(3)
      ..write(obj.cherryTransport)
      ..writeByte(4)
      ..write(obj.laborFullTime)
      ..writeByte(5)
      ..write(obj.laborCasual)
      ..writeByte(6)
      ..write(obj.repairsAndMaintenance)
      ..writeByte(7)
      ..write(obj.otherExpenses)
      ..writeByte(8)
      ..write(obj.ratio)
      ..writeByte(9)
      ..write(obj.expectedProfit)
      ..writeByte(10)
      ..write(obj.sellingType)
      ..writeByte(11)
      ..write(obj.totalSellingPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BasicCalculationEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
