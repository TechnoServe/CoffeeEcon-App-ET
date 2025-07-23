// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalculationHistoryAdapter extends TypeAdapter<CalculationHistory> {
  @override
  final int typeId = 1;

  @override
  CalculationHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalculationHistory(
      fromStage: fields[0] as String,
      toStage: fields[1] as String,
      inputAmount: fields[2] as String,
      resultAmount: fields[3] as String,
      timestamp: fields[4] as DateTime,
      isFromUnitConversion: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CalculationHistory obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.fromStage)
      ..writeByte(1)
      ..write(obj.toStage)
      ..writeByte(2)
      ..write(obj.inputAmount)
      ..writeByte(3)
      ..write(obj.resultAmount)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.isFromUnitConversion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculationHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
