// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'results_overview_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResultsOverviewTypeAdapter extends TypeAdapter<ResultsOverviewType> {
  @override
  final int typeId = 99;

  @override
  ResultsOverviewType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ResultsOverviewType.basic;
      case 1:
        return ResultsOverviewType.advanced;
      case 2:
        return ResultsOverviewType.forecast;
      case 3:
        return ResultsOverviewType.plan;
      default:
        return ResultsOverviewType.basic;
    }
  }

  @override
  void write(BinaryWriter writer, ResultsOverviewType obj) {
    switch (obj) {
      case ResultsOverviewType.basic:
        writer.writeByte(0);
        break;
      case ResultsOverviewType.advanced:
        writer.writeByte(1);
        break;
      case ResultsOverviewType.forecast:
        writer.writeByte(2);
        break;
      case ResultsOverviewType.plan:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultsOverviewTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
