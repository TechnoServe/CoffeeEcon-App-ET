// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advanced_calculation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdvancedCalculationModelAdapter
    extends TypeAdapter<AdvancedCalculationModel> {
  @override
  final int typeId = 6;

  @override
  AdvancedCalculationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdvancedCalculationModel(
      cherryPurchase: fields[1] as String,
      seasonalCoffee: fields[2] as String,
      secondPayment: fields[3] as String,
      lowGradeHulling: fields[4] as String,
      juteBagPrice: fields[5] as String,
      juteBagVolume: fields[6] as String,
      ratio: fields[7] as String,
      procurementExtras: (fields[8] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      transportCost: fields[9] as String,
      commission: fields[10] as String,
      transportExtras: (fields[11] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      casualLabour: fields[12] as String,
      permanentLabour: fields[13] as String,
      overhead: fields[18] as String,
      otherLabour: fields[14] as String,
      fuelCost: fields[15] as String,
      fuelExtras: (fields[16] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      utilities: fields[17] as String,
      annualMaintenance: fields[19] as String,
      dryingBed: fields[20] as String,
      sparePart: fields[21] as String,
      maintenanceExtras: (fields[23] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      otherExpenses: fields[24] as String,
      otherExtras: (fields[25] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      procurementTotal: fields[26] as double,
      transportTotal: fields[27] as double,
      casualTotal: fields[28] as double,
      permanentTotal: fields[29] as double,
      fuelTotal: fields[30] as double,
      maintenanceTotal: fields[31] as double,
      otherTotal: fields[32] as double,
      jutBagTotal: fields[33] as double,
      variableCostTotal: fields[34] as double,
      sellingType: fields[35] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AdvancedCalculationModel obj) {
    writer
      ..writeByte(34)
      ..writeByte(1)
      ..write(obj.cherryPurchase)
      ..writeByte(2)
      ..write(obj.seasonalCoffee)
      ..writeByte(3)
      ..write(obj.secondPayment)
      ..writeByte(4)
      ..write(obj.lowGradeHulling)
      ..writeByte(5)
      ..write(obj.juteBagPrice)
      ..writeByte(6)
      ..write(obj.juteBagVolume)
      ..writeByte(7)
      ..write(obj.ratio)
      ..writeByte(8)
      ..write(obj.procurementExtras)
      ..writeByte(9)
      ..write(obj.transportCost)
      ..writeByte(10)
      ..write(obj.commission)
      ..writeByte(11)
      ..write(obj.transportExtras)
      ..writeByte(12)
      ..write(obj.casualLabour)
      ..writeByte(13)
      ..write(obj.permanentLabour)
      ..writeByte(14)
      ..write(obj.otherLabour)
      ..writeByte(28)
      ..write(obj.casualTotal)
      ..writeByte(29)
      ..write(obj.permanentTotal)
      ..writeByte(18)
      ..write(obj.overhead)
      ..writeByte(15)
      ..write(obj.fuelCost)
      ..writeByte(16)
      ..write(obj.fuelExtras)
      ..writeByte(17)
      ..write(obj.utilities)
      ..writeByte(19)
      ..write(obj.annualMaintenance)
      ..writeByte(20)
      ..write(obj.dryingBed)
      ..writeByte(21)
      ..write(obj.sparePart)
      ..writeByte(23)
      ..write(obj.maintenanceExtras)
      ..writeByte(24)
      ..write(obj.otherExpenses)
      ..writeByte(25)
      ..write(obj.otherExtras)
      ..writeByte(26)
      ..write(obj.procurementTotal)
      ..writeByte(27)
      ..write(obj.transportTotal)
      ..writeByte(30)
      ..write(obj.fuelTotal)
      ..writeByte(31)
      ..write(obj.maintenanceTotal)
      ..writeByte(32)
      ..write(obj.otherTotal)
      ..writeByte(33)
      ..write(obj.jutBagTotal)
      ..writeByte(34)
      ..write(obj.variableCostTotal)
      ..writeByte(35)
      ..write(obj.sellingType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdvancedCalculationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
