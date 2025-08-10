// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operational_planning_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OperationalPlanningModelAdapter
    extends TypeAdapter<OperationalPlanningModel> {
  @override
  final int typeId = 12;

  @override
  OperationalPlanningModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OperationalPlanningModel(
      startDate: fields[7] as DateTime,
      endDate: fields[8] as DateTime,
      selectedCoffeeSellingType: fields[27] as String,
      totalOperatingDays: fields[37] as int,
      dateRangeFormatted: fields[38] as String,
      cherryPurchase: fields[0] as String?,
      seasonalCoffee: fields[1] as String?,
      secondPayment: fields[2] as String?,
      lowGradeHulling: fields[3] as String?,
      juteBagPrice: fields[4] as String?,
      juteBagVolume: fields[5] as String?,
      ratio: fields[6] as String?,
      machineType: fields[9] as String?,
      numMachines: fields[10] as String?,
      numDisks: fields[11] as String?,
      operatingHours: fields[12] as String?,
      fermentationLength: fields[13] as String?,
      fermentationWidth: fields[14] as String?,
      fermentationDepth: fields[15] as String?,
      numberOfFermentationTank: fields[61] as String?,
      fermentationHours: fields[16] as String?,
      soakingLength: fields[17] as String?,
      soakingWidth: fields[18] as String?,
      soakingDepth: fields[19] as String?,
      soakingDuration: fields[20] as String?,
      dryingLength: fields[22] as String?,
      dryingWidth: fields[23] as String?,
      dryingTimeWashed: fields[24] as String?,
      dryingTimeSunDried: fields[25] as String?,
      selectedBagSize: fields[26] as String?,
      pulperHourlyCapacity: fields[28] as double?,
      dailyPulpingCapacity: fields[29] as double?,
      pulpingDays: fields[30] as int?,
      volumeOfFermentationTank: fields[31] as int?,
      soakingTankVolume: fields[32] as int?,
      naturalDailyDryingCapacity: fields[33] as int?,
      washedDailyDryingCapacity: fields[34] as int?,
      numberOfBagsForFullyWashed: fields[35] as int?,
      numberOfBagsForNatural: fields[36] as int?,
      cherryAmount: fields[39] as double?,
      processingDaysForWashed: fields[40] as int?,
      greenCoffeeOutput: fields[41] as double?,
      dryParchmentVolume: fields[42] as double?,
      laborPerBatch: fields[43] as int?,
      batches: fields[44] as int?,
      dryPodVolume: fields[45] as double?,
      totalFerCapacityPerCycle: fields[62] as int?,
      ferTanksPerBatch: fields[63] as int?,
      ferCycleTotal: fields[64] as int?,
      soakingPulpCapacity: fields[201] as int?,
      soakCyclesPerBatch: fields[202] as int?,
      soakingCycleTotal: fields[203] as int?,
      totalWashedDryingBeds: fields[70] as int?,
      totalNatDryingBeds: fields[71] as int?,
      plannedCherriesPerBatch: fields[50] as String,
      selectedSites: (fields[48] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, String>())
          ?.toList(),
      savedTitle: fields[49] as String?,
      id: fields[100] as String?,
      createdAt: fields[46] as DateTime?,
      updatedAt: fields[47] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, OperationalPlanningModel obj) {
    writer
      ..writeByte(60)
      ..writeByte(100)
      ..write(obj.id)
      ..writeByte(0)
      ..write(obj.cherryPurchase)
      ..writeByte(1)
      ..write(obj.seasonalCoffee)
      ..writeByte(2)
      ..write(obj.secondPayment)
      ..writeByte(3)
      ..write(obj.lowGradeHulling)
      ..writeByte(4)
      ..write(obj.juteBagPrice)
      ..writeByte(5)
      ..write(obj.juteBagVolume)
      ..writeByte(6)
      ..write(obj.ratio)
      ..writeByte(7)
      ..write(obj.startDate)
      ..writeByte(8)
      ..write(obj.endDate)
      ..writeByte(9)
      ..write(obj.machineType)
      ..writeByte(10)
      ..write(obj.numMachines)
      ..writeByte(11)
      ..write(obj.numDisks)
      ..writeByte(12)
      ..write(obj.operatingHours)
      ..writeByte(13)
      ..write(obj.fermentationLength)
      ..writeByte(14)
      ..write(obj.fermentationWidth)
      ..writeByte(15)
      ..write(obj.fermentationDepth)
      ..writeByte(61)
      ..write(obj.numberOfFermentationTank)
      ..writeByte(16)
      ..write(obj.fermentationHours)
      ..writeByte(62)
      ..write(obj.totalFerCapacityPerCycle)
      ..writeByte(63)
      ..write(obj.ferTanksPerBatch)
      ..writeByte(64)
      ..write(obj.ferCycleTotal)
      ..writeByte(17)
      ..write(obj.soakingLength)
      ..writeByte(18)
      ..write(obj.soakingWidth)
      ..writeByte(19)
      ..write(obj.soakingDepth)
      ..writeByte(20)
      ..write(obj.soakingDuration)
      ..writeByte(201)
      ..write(obj.soakingPulpCapacity)
      ..writeByte(202)
      ..write(obj.soakCyclesPerBatch)
      ..writeByte(203)
      ..write(obj.soakingCycleTotal)
      ..writeByte(22)
      ..write(obj.dryingLength)
      ..writeByte(23)
      ..write(obj.dryingWidth)
      ..writeByte(24)
      ..write(obj.dryingTimeWashed)
      ..writeByte(25)
      ..write(obj.dryingTimeSunDried)
      ..writeByte(70)
      ..write(obj.totalWashedDryingBeds)
      ..writeByte(71)
      ..write(obj.totalNatDryingBeds)
      ..writeByte(26)
      ..write(obj.selectedBagSize)
      ..writeByte(27)
      ..write(obj.selectedCoffeeSellingType)
      ..writeByte(28)
      ..write(obj.pulperHourlyCapacity)
      ..writeByte(29)
      ..write(obj.dailyPulpingCapacity)
      ..writeByte(30)
      ..write(obj.pulpingDays)
      ..writeByte(31)
      ..write(obj.volumeOfFermentationTank)
      ..writeByte(32)
      ..write(obj.soakingTankVolume)
      ..writeByte(33)
      ..write(obj.naturalDailyDryingCapacity)
      ..writeByte(34)
      ..write(obj.washedDailyDryingCapacity)
      ..writeByte(35)
      ..write(obj.numberOfBagsForFullyWashed)
      ..writeByte(36)
      ..write(obj.numberOfBagsForNatural)
      ..writeByte(37)
      ..write(obj.totalOperatingDays)
      ..writeByte(38)
      ..write(obj.dateRangeFormatted)
      ..writeByte(39)
      ..write(obj.cherryAmount)
      ..writeByte(40)
      ..write(obj.processingDaysForWashed)
      ..writeByte(41)
      ..write(obj.greenCoffeeOutput)
      ..writeByte(42)
      ..write(obj.dryParchmentVolume)
      ..writeByte(43)
      ..write(obj.laborPerBatch)
      ..writeByte(44)
      ..write(obj.batches)
      ..writeByte(45)
      ..write(obj.dryPodVolume)
      ..writeByte(46)
      ..write(obj.createdAt)
      ..writeByte(47)
      ..write(obj.updatedAt)
      ..writeByte(48)
      ..write(obj.selectedSites)
      ..writeByte(49)
      ..write(obj.savedTitle)
      ..writeByte(50)
      ..write(obj.plannedCherriesPerBatch);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperationalPlanningModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
