import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/services/plan_service.dart';
import 'package:flutter_template/app/data/models/operational_planning_model.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PlanController extends GetxController with GetTickerProviderStateMixin {
  final selectedTab = 'Basic'.obs;
  final selectedUnit = 'KG'.obs;
  RxInt currentStep = 0.obs;

  final selectedOutPutValueForWashed = 'Green Coffee'.obs;
  final selectedOutPutValueForNatural = 'Dried Pod'.obs;
  final controller = Get.find<CalculatorController>();

  //coffee processing goal controllers
  final TextEditingController seasonalCoffeeController =
      TextEditingController();
  final PlanService _planService = PlanService();

  final TextEditingController secondPaymentController = TextEditingController();
  final TextEditingController lowGradeHullingController =
      TextEditingController();
  final TextEditingController juteBagPriceController = TextEditingController();
  final TextEditingController juteBagVolumeController = TextEditingController();
  final TextEditingController ratioController =
      TextEditingController(text: '18.0%');
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final RxBool coffeeProcessingAutoValidate = false.obs;
  double fullyWashedPercent = 0.8;
  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();
  final RxList<OperationalPlanningModel> sitePlans =
      <OperationalPlanningModel>[].obs;
  double sunDriedPercent = 0.2;
  //pulping machine
  final TextEditingController machineTypeController =
      TextEditingController(text: 'Disk Pulper');
  final TextEditingController numMachinesController = TextEditingController();
  final TextEditingController numDisksController = TextEditingController();
  final TextEditingController operatingHoursController =
      TextEditingController();
  final RxBool pulpingMachineAutoValidate = false.obs;
  double pulperHourlyCapacity = 0.0;
  double dailyPulpingCapacity = 0.0;
  int pulpingDays = 0;
  int soakingTankPerBatch = 0;

  // Fermentation Tank
  final TextEditingController fermentationLengthController =
      TextEditingController();
  final TextEditingController fermentationWidthController =
      TextEditingController();
  final TextEditingController fermentationDepthController =
      TextEditingController();
  final TextEditingController fermentationHoursController =
      TextEditingController();
  int volumeOfFermentationTank = 0;
  int fermentationTank = 0;
  final double mtPerMeterCube = 1.5;
  // Soaking
  final TextEditingController soakingLengthController = TextEditingController();
  final TextEditingController soakingWidthController = TextEditingController();
  final TextEditingController soakingDepthController = TextEditingController();
  final TextEditingController soakingDurationController =
      TextEditingController();

  final int densityOfWater = 1000; // Density of water is 1000 kg/m3
  int soakingTankVolume = 0;
  int naturalDailyDryingCapacity = 0;
  int washedDailyDryingCapacity = 0;

  // Drying Table
  final TextEditingController dryingLengthController = TextEditingController();
  final TextEditingController dryingWidthController = TextEditingController();
  final TextEditingController dryingTimeWashedController =
      TextEditingController();
  final TextEditingController dryingTimeSunDriedController =
      TextEditingController();

  // Bagging
  final TextEditingController selectedBagSize = TextEditingController();
  final List<String> bagSizes = ['17', '60', '100'];
  int numberOfBagsForFullyWashed = 0;
  int numberOfBagsForNatural = 0;

  final selectedCoffeesellingType = RxnString();
  final RxBool processingSetupAutoValidate = false.obs;

  final List<String> coffeeTypes = [
    'Cherries',
    'Parchment',
    'Green Coffee',
    'Dried pod/Jenfel',
  ];
  static final Map<String, double> conversionFactors = {
    'Cherries': 1,
    'Parchment': 0.2,
    'Green Coffee': 0.16,
    'Dried pod/Jenfel': 0.2,
  };

  // First conversion (Wet Parchment <-> Green Coffee)
  // final selectedOutPutValueForWashed = 'Green coffee'.obs;
  final washedOutputValue = ''.obs;

  // Second conversion (Dried pod <-> Green Coffee)
  // final selectedOutPutValueForNatural = 'Dried pod'.obs;
  final naturalOutputValue = ''.obs;
  PlanController({int initialStep = 0}) {
    currentStep.value = initialStep; // Initialize here
  }
/* 
There are two coffee processing methods: natural (dry) and fully washed (wet).

Fully Washed Process (wet method):
1. Pulping        - Defined in calculatePulpingCapacity()
2. Fermentation   - Defined in calculateFermentation() 
3. Soaking        - Defined in calculateSoaking()
4. Drying         - Defined in calculateDrying()
5. Bagging        - Defined in calculateBagging()

Natural Process (dry method):
1. Drying         - Defined in calculateDrying()
2. Bagging        - Defined in calculateBagging()
*/

  int get getPulpingOperatingHours =>
      int.tryParse(operatingHoursController.text) ?? 0;

  void calculatePulpingCapacity() {
    // Calculate the number of disks and machines from user input
    final double numDisks = double.tryParse(numDisksController.text) ?? 0;
    final double numMachines = double.tryParse(numMachinesController.text) ?? 0;

    // Pulper hourly capacity = number of discs x 1000kg (each disk processes 1000kg/hour)
    pulperHourlyCapacity = numDisks * 1000;

    // Daily capacity = PulperHourly x OperatingHours x NumMachines
    dailyPulpingCapacity =
        pulperHourlyCapacity * getPulpingOperatingHours * numMachines;

    // Calculate the number of days required for pulping based on total cherry amount and daily capacity
    if (dailyPulpingCapacity > 0 && dailyPulpingCapacity.isFinite) {
      pulpingDays = (cherryAmount / dailyPulpingCapacity).isInfinite
          ? (cherryAmount / dailyPulpingCapacity).ceil()
          : 0;
    } else {
      pulpingDays = 0;
    }
  }

  int get getTotalProcessingDaysForWashed {
    final totalHours =
        getPulpingOperatingHours + getFermentingHours + getSoakingHours;
    final totalDays = (totalHours / 24).isFinite ? (totalHours / 24).ceil() : 0;
    return totalDays + getDryingTimeForWashed;
  }

  void calculateFermentation() {
    // Calculate the volume of a single fermentation tank
    final length = double.tryParse(fermentationLengthController.text) ?? 0;
    final width = double.tryParse(fermentationWidthController.text) ?? 0;
    final depth = double.tryParse(fermentationDepthController.text) ?? 0;

    volumeOfFermentationTank =
        (length * width * depth).isFinite ? (length * width * depth).ceil() : 0;

    if (volumeOfFermentationTank == 0) {
      // Handle gracefully
      print('Fermentation tank volume is zero');
      return;
    }

    // Calculate the total volume of parchment to be fermented
    final volumeOfParchment = fullWashedCherry / 1500;

    // Calculate the number of tanks needed
    final numberOfTanksRaw = volumeOfParchment / volumeOfFermentationTank;
    fermentationTank = numberOfTanksRaw.isFinite ? numberOfTanksRaw.ceil() : 0;

    if (numberOfDaysFermenting == 0 || fermentationTank == 0) {
      print('Division by zero in fermentation calculation');
      return;
    }

    // Calculate daily capacity based on tank volume, density, and number of tanks
    final dailyCapacity =
        (volumeOfFermentationTank * mtPerMeterCube * fermentationTank) /
            numberOfDaysFermenting;

    if (dailyCapacity == 0) {
      return;
    }

    // Calculate the number of fermentation days required
    final fermentationDaysRaw = getWetParchmentVolume / dailyCapacity;
    final fermentationDays =
        fermentationDaysRaw.isFinite ? fermentationDaysRaw.ceil() : 0;

    print('Fermentation days: $fermentationDays');
  }

  void calculateSoaking() {
    // Calculate the volume of a single soaking tank
    final length = double.tryParse(soakingLengthController.text) ?? 0;
    final width = double.tryParse(soakingWidthController.text) ?? 0;
    final depth = double.tryParse(soakingDepthController.text) ?? 0;

    final volumeOfSoakingTank = length * width * depth;

    // If density or input is invalid, set to zero
    if (densityOfWater == 0 ||
        densityOfWater.isNaN ||
        getWetParchmentVolume.isNaN) {
      soakingTankVolume = 0;
      soakingTankPerBatch = (soakingTankVolume / volumeOfSoakingTank).isFinite
          ? (soakingTankVolume / volumeOfSoakingTank).ceil()
          : 0;
    } else {
      // Calculate the percent of fully washed coffee based on selling type
      final calculatedFullyWashedPercent =
          selectedCoffeesellingType.value == 'Parchment'
              ? 1
              : fullyWashedPercent;
      // Calculate the total soaking tank volume needed
      soakingTankVolume =
          ((getWetParchmentVolume * calculatedFullyWashedPercent) /
                      densityOfWater)
                  .isFinite
              ? ((getWetParchmentVolume * calculatedFullyWashedPercent) /
                      densityOfWater)
                  .ceil()
              : 0;

      if (volumeOfSoakingTank == 0 || volumeOfSoakingTank.isNaN) {
        soakingTankPerBatch = 0;
      } else {
        // Calculate the number of batches needed
        final result = soakingTankVolume / volumeOfSoakingTank;
        soakingTankPerBatch = result.isFinite ? result.ceil() : 0;
      }
    }
  }

  double safeDivide(double numerator, double denominator) {
    if (denominator == 0 || denominator.isNaN || numerator.isNaN) return 0;
    return numerator / denominator;
  }

  int safeCeil(double value) {
    if (value.isNaN || value.isInfinite) return 0;
    return value.ceil();
  }

  int get getDryingTimeForWashed =>
      int.tryParse(dryingTimeWashedController.text) ?? 0;

  void calculateDrying() {
    // Calculate the area of a drying bed
    final dryingBedArea = (double.tryParse(dryingLengthController.text) ?? 0) *
        (double.tryParse(dryingWidthController.text) ?? 0);
    // Drying capacity per bed for natural and washed processes (constants)
    final dryingCapacityPerBedForNatural =
        dryingBedArea * 11; // 11 is some constant
    final dryingCapacityPerBedForWashed =
        dryingBedArea * 13.5; // 13.5 is some constant

    // Calculate the percent of fully washed coffee based on selling type
    final calculatedFullyWashedPercent =
        selectedCoffeesellingType.value == 'Parchment' ? 1 : fullyWashedPercent;
    // 0.39 is a conversion factor to wet parchment since it lost some amount during pulping, soaking, etc.
    final capacity = (cherryAmount * 0.39 * calculatedFullyWashedPercent) /
        dryingCapacityPerBedForWashed;
    washedDailyDryingCapacity = capacity.isFinite ? capacity.ceil() : 0;

    // Calculate the percent of sun dried coffee based on selling type
    final calculatedSunDriedPercent =
        selectedCoffeesellingType.value == 'Dried pod/Jenfel'
            ? 1
            : sunDriedPercent;
    final naturalCapacity = (cherryAmount * calculatedSunDriedPercent) /
        dryingCapacityPerBedForNatural;
    naturalDailyDryingCapacity =
        naturalCapacity.isFinite ? naturalCapacity.ceil() : 0;
  }

  int get parchmentBags {
    // Calculate the number of parchment bags needed
    final calculatedFullyWashedPercent =
        selectedCoffeesellingType.value == 'Parchment' ? 1 : fullyWashedPercent;
    return ((cherryAmount * 0.2 * calculatedFullyWashedPercent) /
                (double.tryParse(selectedBagSize.text) ?? 0))
            .isFinite
        ? ((cherryAmount * 0.2 * calculatedFullyWashedPercent) /
                (double.tryParse(selectedBagSize.text) ?? 0))
            .ceil()
            .toInt()
        : 0;
  }

  int get greenBeanBags {
    // Calculate the number of green bean bags needed
    final calculatedSunDriedPercent =
        selectedCoffeesellingType.value == 'Dried pod/Jenfel'
            ? 1
            : sunDriedPercent;
    return ((cherryAmount * 0.16 * calculatedSunDriedPercent) /
                (double.tryParse(selectedBagSize.text) ?? 0))
            .isFinite
        ? ((cherryAmount * 0.16 * calculatedSunDriedPercent) /
                (double.tryParse(selectedBagSize.text) ?? 0))
            .ceil()
            .toInt()
        : 0;
  }

  void calculateBagging() {
    // 0.16 unsorted green coffee conversion factor relative to cherry
    // Calculate number of bags for fully washed process
    final calculatedFullyWashedPercent =
        selectedCoffeesellingType.value == 'Parchment' ? 1 : fullyWashedPercent;
    numberOfBagsForFullyWashed =
        ((cherryAmount * 0.16 * calculatedFullyWashedPercent) /
                    (double.tryParse(selectedBagSize.text) ?? 0))
                .isFinite
            ? ((cherryAmount * 0.16 * calculatedFullyWashedPercent) /
                    (double.tryParse(selectedBagSize.text) ?? 0))
                .ceil()
                .toInt()
            : 0;

    // Calculate number of bags for natural process
    final calculatedSunDriedPercent =
        selectedCoffeesellingType.value == 'Dried pod/Jenfel'
            ? 1
            : sunDriedPercent;

    numberOfBagsForNatural = ((cherryAmount * 0.2 * calculatedSunDriedPercent) /
                (double.tryParse(selectedBagSize.text) ?? 0))
            .isFinite
        ? ((cherryAmount * 0.2 * calculatedSunDriedPercent) /
                (double.tryParse(selectedBagSize.text) ?? 0))
            .ceil()
            .toInt()
        : 0;
  }

// Number of workers(Fully Washed) = (total kg of cherry x by the fully washed percentage ) ÷ 500 kg worker/day
// Number of workers(Natural) = (total kg of cherry x by the natural  percentage ) ÷ 500 kg worker/day

  int get numberOfWorkersForFullyWashed {
    // Number of workers for fully washed process = (total kg of cherry x fully washed percent) / 500 kg per worker per day
    final calculatedFullyWashedPercent =
        selectedCoffeesellingType.value == 'Parchment' ? 1 : fullyWashedPercent;
    return ((cherryAmount * calculatedFullyWashedPercent) / 500).isFinite
        ? ((cherryAmount * calculatedFullyWashedPercent) / 500).ceil()
        : 0;
  }

  double get fullWashedCherry => cherryAmount * fullyWashedPercent;
  int get numberOfWorkersForNatural {
    // Number of workers for natural process = (total kg of cherry x natural percent) / 500 kg per worker per day
    final calculatedSunDriedPercent =
        selectedCoffeesellingType.value == 'Dried pod/Jenfel'
            ? 1
            : sunDriedPercent;
    return ((cherryAmount * calculatedSunDriedPercent) / 500).isFinite
        ? ((cherryAmount * calculatedSunDriedPercent) / 500).ceil()
        : 0;
  }

  int get wareHousePlanning =>
      numberOfBagsForFullyWashed + numberOfBagsForNatural;

  double get cherryAmount {
    // Calculate the cherry amount based on selected coffee selling type and conversion factors
    if (selectedCoffeesellingType.value == 'Cherries') {
      return double.tryParse(seasonalCoffeeController.text) ?? 0;
    }
    return (double.tryParse(seasonalCoffeeController.text) ?? 0) /
        (conversionFactors[selectedCoffeesellingType.value] ?? 0);
  }

  int get numberOfDaysFermenting {
    // Calculate the number of fermenting days (round up to nearest day)
    final days = getFermentingHours / 24;
    return days.ceil(); // Rounds up to the nearest whole day
  }

  int get getFermentingHours =>
      int.tryParse(fermentationHoursController.text) ?? 0;
  int get getSoakingHours => int.tryParse(soakingDurationController.text) ?? 0;
  int get getWashedDryingHours =>
      int.tryParse(dryingTimeWashedController.text) ?? 0;

  double get getWetParchmentVolume {
    // 39% conversion from cherry to wet parchment
    const conversionRate = 0.39;
    return cherryAmount * conversionRate;
  }

  double get getDryParchmentVolume {
    // 20% conversion from cherry to dry parchment
    const conversionRate = 0.20;
    return cherryAmount * conversionRate;
  }

  double get getDryPodVolume {
    // 12% conversion from cherry to dry pod
    const conversionRate = 0.12;
    return cherryAmount * conversionRate;
  }

  double get getGreenCoffeeOutput {
    // Dried Pod : Green Coffee = 1.25 : 1, so divide dry pod volume by 1.25
    const double conversionRate = 1.25;
    return getDryPodVolume / conversionRate;
  }

//The system will count from the start date to the end date excluding Sundays and will display the total operating day.
  int get totalOperatingDays {
    // Calculate the total number of operating days between start and end date, excluding Sundays
    if (startDate.value == null || endDate.value == null) return 0;

    print('START: [38;5;246m[48;5;236m${startDate.value}[0m');
    print('END: [38;5;246m[48;5;236m${endDate.value}[0m');

    int count = 0;
    DateTime current = startDate.value!;

    while (!current.isAfter(endDate.value!)) {
      if (current.weekday != DateTime.sunday) {
        count++;
      }
      current = current.add(const Duration(days: 1));
    }

    return count;
  }

  String get dateRangeFormatted {
    if (startDate.value == null || endDate.value == null) return '';
    final formatter = DateFormat('MMM d, yyyy');
    return '${formatter.format(startDate.value!)}  -  ${formatter.format(endDate.value!)}';
  }
  // 0.16 unsorted green coffee conversion factor relative to cherry

  void calculateWashedOutput() {
    // Calculate washed output value based on selected coffee selling type
    if (selectedCoffeesellingType.value == 'Parchment') {
      washedOutputValue.value = (cherryAmount * 0.16).toStringAsFixed(2);
    } else {
      washedOutputValue.value =
          (cherryAmount * fullyWashedPercent * 0.16).toStringAsFixed(2);
    }
  }

  void calculateNaturalOutput() {
    // Calculate natural output value based on selected coffee selling type
    if (selectedCoffeesellingType.value == 'Dried pod/Jenfel') {
      naturalOutputValue.value = (cherryAmount * 0.2).toStringAsFixed(2);
    } else {
      naturalOutputValue.value =
          (cherryAmount * sunDriedPercent * 0.2).toStringAsFixed(2);
    }
  }

  void updateOutPutValueForWashed(String value) {
    // Update washed output value based on user selection (Green Coffee or Parchment)
    if (value == selectedOutPutValueForWashed.value) return; // No change
    //when Green Coffee selecte multiply the cherry amount by fullyWashedpercencatage * 0.16
    //when parchment selected multiply the cherry amount by fullyWashedpercencatage * 0.2
    double? parsed = double.tryParse(washedOutputValue.value);
    if (parsed == null) {
      washedOutputValue.value = 'Invalid input';
      return;
    }
    //200,000 = green coffee 160,000 and dried pod same
    final calculatedFullyWashedPercent =
        selectedCoffeesellingType.value == 'Parchment' ? 1 : fullyWashedPercent;
    if (value == 'Green Coffee') {
      parsed = cherryAmount * calculatedFullyWashedPercent * 0.16;
    } else {
      parsed = cherryAmount * calculatedFullyWashedPercent * 0.2;
    }

    washedOutputValue.value = parsed.toStringAsFixed(2);
    selectedOutPutValueForWashed.value = value;
  }

  void updateOutPutValueForNatural(String value) {
    // Update natural output value based on user selection (Green Bean or Dried Pod)
    if (value == selectedOutPutValueForNatural.value) return; // No change

    double? parsed = double.tryParse(naturalOutputValue.value);
    if (parsed == null) {
      naturalOutputValue.value = 'Invalid input';
      return;
    }

    //when green bean selecte multiply the cherry amount by percencatage * 0.16
    //when driedpod selectedw multiply the cherry amount by percencatage * 0.2

    // Apply new conversion
    final calculatedSunDriedPercent =
        selectedCoffeesellingType.value == 'Dried pod/Jenfel'
            ? 1
            : sunDriedPercent;
    if (value == 'Green Bean') {
      parsed = cherryAmount * calculatedSunDriedPercent * 0.16;
    } else {
      parsed = cherryAmount * calculatedSunDriedPercent * 0.2;
    }
    naturalOutputValue.value = parsed.toStringAsFixed(2);
    selectedOutPutValueForNatural.value = value;
  }

  void onDataSubmit() {
    Get.toNamed<void>(
      AppRoutes.OPERATIONAL_SUMMARY,
      arguments: {
        'data': buildOperationalPlanningData(),
        'isFromTable': false,
      },
    );
  }

  void loadPlansBySite({required String siteId}) {
    sitePlans.assignAll(
      _planService.getPlansBySite(siteId: siteId),
    );
  }

  Future<void> savePlan({
    required List<Map<String, String>> selectedSites,
    required String planName,
  }) async {
    try {
      final planData = buildOperationalPlanningData(
        selectedSites: selectedSites,
        planName: planName,
      );
      await _planService.addPlan(planData);

      // _planService.getAllPlans();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to store your calculation, please try again.',
        backgroundColor: AppColors.error,
        colorText: AppColors.textWhite100,
      );
    }
  }

//(pulpingOperatinghours + fermantionHours + soakingHours = divided by 24 to ceil ) + dryingDays = processingDaysPerBatch
  OperationalPlanningModel buildOperationalPlanningData({
    List<Map<String, String>> selectedSites = const [],
    String planName = '',
  }) =>
      OperationalPlanningModel(
        savedTitle: planName,
        startDate: startDate.value!,
        endDate: endDate.value!,
        selectedCoffeeSellingType: selectedCoffeesellingType.value!,
        totalOperatingDays: totalOperatingDays,
        dateRangeFormatted: dateRangeFormatted,
        cherryPurchase: seasonalCoffeeController.text,
        seasonalCoffee: seasonalCoffeeController.text,
        secondPayment: secondPaymentController.text,
        lowGradeHulling: lowGradeHullingController.text,
        juteBagPrice: juteBagPriceController.text,
        juteBagVolume: juteBagVolumeController.text,
        ratio: ratioController.text,
        machineType: machineTypeController.text,
        numMachines: numMachinesController.text,
        numDisks: numDisksController.text,
        operatingHours: operatingHoursController.text,
        fermentationLength: fermentationLengthController.text,
        fermentationWidth: fermentationWidthController.text,
        fermentationDepth: fermentationDepthController.text,
        fermentationHours: fermentationHoursController.text,
        soakingLength: soakingLengthController.text,
        soakingWidth: soakingWidthController.text,
        soakingDepth: soakingDepthController.text,
        soakingDuration: soakingDurationController.text,
        dryingLength: dryingLengthController.text,
        dryingWidth: dryingWidthController.text,
        dryingTimeWashed: dryingTimeWashedController.text,
        dryingTimeSunDried: dryingTimeSunDriedController.text,
        selectedBagSize: selectedBagSize.text,
        pulperHourlyCapacity: pulperHourlyCapacity,
        dailyPulpingCapacity: dailyPulpingCapacity,
        pulpingDays: pulpingDays,
        volumeOfFermentationTank: fermentationTank,
        soakingTankVolume: soakingTankPerBatch,
        naturalDailyDryingCapacity: naturalDailyDryingCapacity,
        washedDailyDryingCapacity: washedDailyDryingCapacity,
        numberOfBagsForFullyWashed: numberOfBagsForFullyWashed,
        numberOfBagsForNatural: numberOfBagsForNatural,
        cherryAmount: cherryAmount,
        processingDaysForWashed: getTotalProcessingDaysForWashed,
        greenCoffeeOutput: getGreenCoffeeOutput,
        dryParchmentVolume: getDryParchmentVolume,
        dryPodVolume: getDryPodVolume,
        numberOfWorkersForNatural: numberOfWorkersForNatural,
        numberOfWorkersForFullyWashed: numberOfWorkersForFullyWashed,
        selectedSites: selectedSites,
      );
  void patchOperationalPlanningData(OperationalPlanningModel data) {
    startDate.value = data.startDate;
    endDate.value = data.endDate;

    selectedCoffeesellingType.value = data.selectedCoffeeSellingType;

    seasonalCoffeeController.text = data.seasonalCoffee ?? '';
    secondPaymentController.text = data.secondPayment ?? '';
    lowGradeHullingController.text = data.lowGradeHulling ?? '';
    juteBagPriceController.text = data.juteBagPrice ?? '';
    juteBagVolumeController.text = data.juteBagVolume ?? '';
    ratioController.text = data.ratio ?? '';
    machineTypeController.text = data.machineType ?? '';
    numMachinesController.text = data.numMachines ?? '';
    numDisksController.text = data.numDisks ?? '';
    operatingHoursController.text = data.operatingHours ?? '';
    fermentationLengthController.text = data.fermentationLength ?? '';
    fermentationWidthController.text = data.fermentationWidth ?? '';
    fermentationDepthController.text = data.fermentationDepth ?? '';
    fermentationHoursController.text = data.fermentationHours ?? '';
    soakingLengthController.text = data.soakingLength ?? '';
    soakingWidthController.text = data.soakingWidth ?? '';
    soakingDepthController.text = data.soakingDepth ?? '';
    soakingDurationController.text = data.soakingDuration ?? '';
    dryingLengthController.text = data.dryingLength ?? '';
    dryingWidthController.text = data.dryingWidth ?? '';
    dryingTimeWashedController.text = data.dryingTimeWashed ?? '';
    dryingTimeSunDriedController.text = data.dryingTimeSunDried ?? '';
    selectedBagSize.text = data.selectedBagSize ?? '';

    pulperHourlyCapacity = data.pulperHourlyCapacity ?? 0;
    dailyPulpingCapacity = data.dailyPulpingCapacity ?? 0;
    pulpingDays = data.pulpingDays ?? 0;
    fermentationTank = data.volumeOfFermentationTank ?? 0;
    soakingTankPerBatch = data.soakingTankVolume ?? 0;
    naturalDailyDryingCapacity = data.naturalDailyDryingCapacity ?? 0;
    washedDailyDryingCapacity = data.washedDailyDryingCapacity ?? 0;
    numberOfBagsForFullyWashed = data.numberOfBagsForFullyWashed ?? 0;
    numberOfBagsForNatural = data.numberOfBagsForNatural ?? 0;
    // cherryAmount = data.cherryAmount ?? 0;
    // getTotalProcessingDaysForWashed = data.processingDaysForWashed ?? 0;
    // getGreenCoffeeOutput = data.greenCoffeeOutput ?? 0;
    // getDryParchmentVolume = data.dryParchmentVolume ?? 0;
    // getDryPodVolume = data.dryPodVolume ?? 0;
    // numberOfWorkersForNatural = data.numberOfWorkersForNatural ?? 0;
    // numberOfWorkersForFullyWashed = data.numberOfWorkersForFullyWashed ?? 0;
  }

  @override
  void onClose() {
    // seasonalCoffeeController.dispose();
    // seasonalCoffeeController.dispose();
    // secondPaymentController.dispose();
    // lowGradeHullingController.dispose();
    // juteBagPriceController.dispose();
    // juteBagVolumeController.dispose();
    // ratioController.dispose();
    // startDateController.dispose();
    // endDateController.dispose();
    // machineTypeController.dispose();
    // numMachinesController.dispose();
    // numDisksController.dispose();
    // operatingHoursController.dispose();
    // startDateController.dispose();
    // endDateController.dispose();

    // //washed process controllers
    // fermentationLengthController.dispose();
    // fermentationWidthController.dispose();
    // fermentationDepthController.dispose();
    // fermentationHoursController.dispose();
    // soakingLengthController.dispose();
    // soakingWidthController.dispose();
    // soakingDepthController.dispose();
    // soakingDurationController.dispose();
    // dryingLengthController.dispose();
    // dryingWidthController.dispose();
    // dryingTimeWashedController.dispose();
    // dryingTimeSunDriedController.dispose();

    controller.selectedSite = [];

    super.dispose();
  }
}
