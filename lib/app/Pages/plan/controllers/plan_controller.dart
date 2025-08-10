import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/best_practice_modal.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/services/plan_service.dart';
import 'package:flutter_template/app/data/models/operational_planning_model.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Controller for managing operational planning and coffee processing calculations.
///
/// This controller orchestrates the multi-step planning process for coffee processing operations.
/// It manages all user input, state, and business logic for:
/// - Setting processing goals (cherry input, output types, date ranges)
/// - Calculating machine and labor requirements for each processing stage
/// - Handling both fully washed (wet) and natural (dry) coffee processes
/// - Converting between different coffee product types using industry-standard ratios
/// - Managing plan persistence, loading, and site-specific filtering
///
/// The controller is designed for use with GetX and supports reactive state updates for the UI.
class PlanController extends GetxController with GetTickerProviderStateMixin {
  /// Currently selected tab ("Basic" or other types)
  final selectedTab = 'Basic'.obs;
  /// Currently selected unit (e.g., KG)
  final selectedUnit = 'KG'.obs;
  /// Current step in the multi-step planning process
  RxInt currentStep = 0.obs;
 int laborPerBatch = 0;
 int batches = 0;
  /// Output type selection for washed and natural processes
  final selectedOutPutValueForWashed = 'Green Coffee'.obs;
  final selectedOutPutValueForNatural = 'Dried Pod'.obs;
  /// Reference to the calculator controller for shared logic
  final controller = Get.find<CalculatorController>();

  //coffee processing goal controllers
  /// User input for seasonal coffee purchase volume
  final TextEditingController seasonalCoffeeController =
      TextEditingController();
    /// User input for planned cherries per batch
  final TextEditingController plannedCherriesPerBatch =
      TextEditingController();    
  /// Service for plan persistence and retrieval
  final PlanService _planService = PlanService();

  /// User input for second payment, hulling, jute bag, ratio, and date range
  final TextEditingController secondPaymentController = TextEditingController();
  final TextEditingController lowGradeHullingController =
      TextEditingController();
  final TextEditingController juteBagPriceController = TextEditingController();
  final TextEditingController juteBagVolumeController = TextEditingController();
  final TextEditingController ratioController =
      TextEditingController(text: '18.0%');
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  /// Whether to auto-validate processing goal form
  final RxBool coffeeProcessingAutoValidate = false.obs;
  /// Default percent split for fully washed and sun dried processes
  Rx<double> fullyWashedPercent = 0.8.obs;
  /// Selected date range for planning
  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();
  /// List of plans for the current site
  final RxList<OperationalPlanningModel> sitePlans =
      <OperationalPlanningModel>[].obs;
  Rx<double> sunDriedPercent = 0.2.obs;
  //pulping machine
  /// User input for machine type, number of machines, disks, and operating hours
  final TextEditingController machineTypeController =
      TextEditingController(text: 'Disk Pulper'.tr);
  final TextEditingController numMachinesController = TextEditingController();
  final TextEditingController numDisksController = TextEditingController();
  final TextEditingController operatingHoursController =
      TextEditingController();
  /// Whether to auto-validate pulping machine form
  final RxBool pulpingMachineAutoValidate = false.obs;
  /// Calculated capacity values for pulping operations
  double pulperHourlyCapacity = 0.0;
  double dailyPulpingCapacity = 0.0;
  int pulpingDays = 0;
  int soakingTankPerBatch = 0;

  // Fermentation Tank
  /// User input for fermentation tank dimensions and duration
  final TextEditingController fermentationLengthController =
      TextEditingController();
  final TextEditingController fermentationWidthController =
      TextEditingController();
  final TextEditingController fermentationDepthController =
      TextEditingController();
    final TextEditingController numberOfFermentationTank =
      TextEditingController();    
  final TextEditingController fermentationHoursController =
      TextEditingController();
  /// Calculated fermentation tank requirements
  int volumeOfFermentationTank = 0;
  int fermentationTank = 0;
  /// Metric tons per cubic meter conversion factor
  final double mtPerMeterCube = 1.5;
  // Soaking
  /// User input for soaking tank dimensions and duration
  final TextEditingController soakingLengthController = TextEditingController();
  final TextEditingController soakingWidthController = TextEditingController();
  final TextEditingController soakingDepthController = TextEditingController();
  final TextEditingController soakingDurationController =
      TextEditingController();

  /// Density of water in kg/m³ for volume calculations
  final int densityOfWater = 1000; // Density of water is 1000 kg/m3
  /// Calculated soaking tank requirements
  int soakingTankVolume = 0;
  int naturalDailyDryingCapacity = 0;
  int washedDailyDryingCapacity = 0;
  int totalWashedDryingBeds = 0;
  int totalNatDryingBeds = 0;

  // Drying Table
  /// User input for drying bed dimensions and time requirements
  final TextEditingController dryingLengthController = TextEditingController();
  final TextEditingController dryingWidthController = TextEditingController();
  final TextEditingController dryingTimeWashedController =
      TextEditingController();
  final TextEditingController dryingTimeSunDriedController =
      TextEditingController();

  // Bagging
  /// User input for bag size selection and calculated bag requirements
  final TextEditingController selectedBagSize = TextEditingController();
  final List<String> bagSizes = ['17', '60', '100'];
  int numberOfBagsForFullyWashed = 0;
  int numberOfBagsForNatural = 0;

  /// Currently selected coffee selling type (e.g., Cherries, Parchment)
  final selectedCoffeesellingType = RxnString();
  /// Whether to auto-validate processing setup form
  final RxBool processingSetupAutoValidate = false.obs;

  /// Supported coffee types for planning
  final List<String> coffeeTypes = [
    'Cherries',
    'Parchment',
    'Green Coffee',
    'Dried pod/Jenfel',
  ];
  /// Conversion factors for each coffee type (relative to cherry)
  static final Map<String, double> conversionFactors = {
    'Cherries': 1,
    'Parchment': 0.2,
    'Green Coffee': 0.16,
    'Dried pod/Jenfel': 0.2,
  };

  Rx<bool> showBottleNeck = true.obs;
  
  int totalFerCapacityPerCycle = 0;
  int ferTanksPerBatch = 0;
  int ferCycleTotal = 0;

  int soakingPulpCapacity = 0;
  int soakCyclesPerBatch = 0;
  int soakingCycleTotal = 0;
  // First conversion (Wet Parchment <-> Green Coffee)
  // final selectedOutPutValueForWashed = 'Green coffee'.obs;
  /// Calculated output values for washed and natural processes
  final washedOutputValue = ''.obs;

  // Second conversion (Dried pod <-> Green Coffee)
  // final selectedOutPutValueForNatural = 'Dried pod'.obs;
  final naturalOutputValue = ''.obs;
  
  /// Constructor allows setting the initial step for multi-step flows
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

  /// Retrieves the pulping operating hours from user input
  int get getPulpingOperatingHours =>
      int.tryParse(operatingHoursController.text) ?? 0;

  /// Calculates the pulping machine's daily and hourly capacity based on user input.
  ///
  /// This is a key step in the fully washed process, determining how much cherry can be processed per day.
  /// The calculation uses industry-standard assumptions about disk capacity and machine efficiency.
  void calculatePulpingCapacity() {
    // Calculate the number of disks and machines from user input
    final double numDisks = double.tryParse(numDisksController.text) ?? 0;
    final double numMachines = double.tryParse(numMachinesController.text) ?? 0;

    // Pulper hourly capacity = number of discs x 1000kg (each disk processes 1000kg/hour)
    pulperHourlyCapacity = numDisks * 1000;

    // Daily capacity = PulperHourly x OperatingHours x NumMachines
    dailyPulpingCapacity =
        pulperHourlyCapacity * getPulpingOperatingHours;

    // Calculate the number of days required for pulping based on total cherry amount and daily capacity
    if (dailyPulpingCapacity > 0 && dailyPulpingCapacity.isFinite) {
      pulpingDays = (cherryAmount / dailyPulpingCapacity).isInfinite
          ? (cherryAmount / dailyPulpingCapacity).ceil()
          : 0;
    } else {
      pulpingDays = 0;
    }
  }

  /// Calculates the total processing days for the washed process.
  ///
  /// Sums pulping, fermenting, and soaking hours, divides by 24, and adds drying time for washed.
  /// This provides the total time required for the complete washed process.
  int get getTotalProcessingDaysForWashed {
    final totalHours =
        getPulpingOperatingHours + getFermentingHours + getSoakingHours;
    final totalDays = (totalHours / 24).isFinite ? (totalHours / 24).ceil() : 0;
    return totalDays + getDryingTimeForWashed;
  }

  double get cherryBatch => double.parse(plannedCherriesPerBatch.text);
  /// Calculates the number of fermentation tanks and days required for the process.
  ///
  /// Uses tank dimensions, cherry input, and process duration to determine requirements.
  /// The calculation accounts for the conversion from cherry to wet parchment and tank capacity.
  void calculateFermentation() {
    // Calculate the volume of a single fermentation tank
    final length = double.tryParse(fermentationLengthController.text) ?? 0;
    final width = double.tryParse(fermentationWidthController.text) ?? 0;
    final depth = double.tryParse(fermentationDepthController.text) ?? 0;
    const pulpToWaterRatio = 1;
    const tankUsableRatio = 0.85;
    const cherryToWetParchment = 0.39;

   
    volumeOfFermentationTank =
        (length * width * depth).isFinite ? (length * width * depth * 907.4).ceil() : 0;
    final usableFerTankVol = volumeOfFermentationTank * tankUsableRatio;
    
    final perTankPulpCapacity = usableFerTankVol / (1 + pulpToWaterRatio);
   
    totalFerCapacityPerCycle = (perTankPulpCapacity * double.parse(numberOfFermentationTank.text)).ceil();
    ferTanksPerBatch =  ceilSafe((cherryBatch * 0.55) / perTankPulpCapacity);
    
  
    final parchmentAmount = cherryBatch * cherryToWetParchment;

    final fermentCyclesPerBatch = ceilSafe(parchmentAmount / totalFerCapacityPerCycle) * batches;
    ferCycleTotal =  fermentCyclesPerBatch * batches;

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

  /// Calculates the soaking tank requirements and batch counts.
  ///
  /// Uses tank dimensions, water density, and cherry input to determine soaking needs.
  /// The calculation accounts for the percentage of fully washed coffee and water displacement.
  void calculateSoaking() {
    // Calculate the volume of a single soaking tank
    final length = double.tryParse(soakingLengthController.text) ?? 0;
    final width = double.tryParse(soakingWidthController.text) ?? 0;
    final depth = double.tryParse(soakingDepthController.text) ?? 0;
    const tankUsableRatio = 0.85;
    const pulpToWaterRatio = 1;
    const cherryToWetParchment = 0.39;

    final parchmentAmount = cherryBatch * cherryToWetParchment;
    final batches = ceilSafe(cherryAmount / cherryBatch);

    final volumeOfSoakingTank = length * width * depth;
    final soakingTankLiters = volumeOfSoakingTank * 907.4;
    final usableSoakTank = soakingTankLiters * tankUsableRatio;
    //Soaking capacity per cycle (kg)
     soakingPulpCapacity = (usableSoakTank / (1 + pulpToWaterRatio)).ceil();
     //Soaking cycles per batch
     soakCyclesPerBatch = ceilSafe(parchmentAmount / soakingPulpCapacity);
    //Soaking cycles total
     soakingCycleTotal = soakCyclesPerBatch * batches;
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
          selectedCoffeesellingType.value == 'Parchment' || fullyWashedPercent.value == 1.0
              ? 1
              : fullyWashedPercent.value;
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
  

  /// Safely divides two numbers, returning 0 if the denominator is zero or invalid.
  /// This prevents division by zero errors in calculations.
  double safeDivide(double numerator, double denominator) {
    if (denominator == 0 || denominator.isNaN || numerator.isNaN) return 0;
    return numerator / denominator;
  }

  /// Safely rounds a double value to the nearest integer, returning 0 for invalid values.
  /// This prevents errors when dealing with NaN or infinite values.
  int safeCeil(double value) {
    if (value.isNaN || value.isInfinite) return 0;
    return value.ceil();
  }

  /// Retrieves the drying time for the washed process from user input
  int get getDryingTimeForWashed =>
      int.tryParse(dryingTimeWashedController.text) ?? 0;

  /// Calculates the drying bed requirements for both natural and washed processes.
  ///
  /// Uses drying bed area, cherry input, and process type to determine daily drying capacity.
  /// Different capacity factors are used for natural vs washed processes due to moisture content differences.
  void calculateDrying() {
    // Calculate the area of a drying bed
    final dryingBedArea = (double.tryParse(dryingLengthController.text) ?? 0) *
        (double.tryParse(dryingWidthController.text) ?? 0);
   final cherryBatch = double.parse(plannedCherriesPerBatch.text);
   const cherryToWetParchment = 0.39;
   final parchmentAmount = cherryBatch * cherryToWetParchment;

    // Drying capacity per bed for natural and washed processes (constants)
    final dryingCapacityPerBedForNatural =
        dryingBedArea * 11; // 11 is some constant
    final dryingCapacityPerBedForWashed =
        dryingBedArea * 13.5; // 13.5 is some constant

    final batches = ceilSafe(cherryAmount / cherryBatch);
    
    // Calculate the percent of fully washed coffee based on selling type
    final calculatedFullyWashedPercent =
        selectedCoffeesellingType.value == 'Parchment' || fullyWashedPercent.value == 1.0 ? 1 : fullyWashedPercent.value;
    // 0.39 is a conversion factor to wet parchment since it lost some amount during pulping, soaking, etc.
    final capacity = parchmentAmount /
        dryingCapacityPerBedForWashed;
    washedDailyDryingCapacity = capacity.isFinite ? capacity.ceil() : 0;
    totalWashedDryingBeds =     washedDailyDryingCapacity * batches;

    // Calculate the percent of sun dried coffee based on selling type
    final calculatedSunDriedPercent =
        selectedCoffeesellingType.value == 'Dried pod/Jenfel'
            ? 1
            : sunDriedPercent.value;
    final naturalCapacity = parchmentAmount /
        dryingCapacityPerBedForNatural;
    naturalDailyDryingCapacity =
        naturalCapacity.isFinite ? naturalCapacity.ceil() : 0;
    totalNatDryingBeds =     naturalDailyDryingCapacity * batches;
    
  }

  /// Calculates the number of parchment bags needed for the washed process.
  ///
  /// Uses cherry input, conversion factors, and selected bag size.
  /// The 0.2 factor represents the conversion from cherry to parchment.
  int get parchmentBags {
    // Calculate the number of parchment bags needed
    final calculatedFullyWashedPercent =
        selectedCoffeesellingType.value == 'Parchment'  || fullyWashedPercent.value == 1.0 ? 1 : fullyWashedPercent.value;
    return ((cherryAmount * 0.2 * calculatedFullyWashedPercent) /
                (double.tryParse(selectedBagSize.text) ?? 0))
            .isFinite
        ? ((cherryAmount * 0.2 * calculatedFullyWashedPercent) /
                (double.tryParse(selectedBagSize.text) ?? 0))
            .ceil()
            .toInt()
        : 0;
  }

  /// Calculates the number of green bean bags needed for the natural process.
  ///
  /// Uses cherry input, conversion factors, and selected bag size.
  /// The 0.16 factor represents the conversion from cherry to green coffee.
  int get greenBeanBags {
    // Calculate the number of green bean bags needed
    final calculatedSunDriedPercent =
        selectedCoffeesellingType.value == 'Dried pod/Jenfel' || sunDriedPercent.value == 1
            ? 1
            : sunDriedPercent.value;
    return ((cherryAmount * 0.16 * calculatedSunDriedPercent) /
                (double.tryParse(selectedBagSize.text) ?? 0))
            .isFinite
        ? ((cherryAmount * 0.16 * calculatedSunDriedPercent) /
                (double.tryParse(selectedBagSize.text) ?? 0))
            .ceil()
            .toInt()
        : 0;
  }

  /// Calculates the number of bags needed for each process output.
  ///
  /// Uses cherry input, conversion factors, and selected bag size.
  /// Different conversion factors are used for washed vs natural processes.
  void calculateBagging() {
    // 0.16 unsorted green coffee conversion factor relative to cherry
    // Calculate number of bags for fully washed process
    final calculatedFullyWashedPercent =
        selectedCoffeesellingType.value == 'Parchment' || fullyWashedPercent.value == 1.0 ? 1 : fullyWashedPercent.value;
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
        selectedCoffeesellingType.value == 'Dried pod/Jenfel' || sunDriedPercent.value == 1
            ? 1
            : sunDriedPercent.value;

    numberOfBagsForNatural = ((cherryAmount * 0.2 * calculatedSunDriedPercent) /
                (double.tryParse(selectedBagSize.text) ?? 0))
            .isFinite
        ? ((cherryAmount * 0.2 * calculatedSunDriedPercent) /
                (double.tryParse(selectedBagSize.text) ?? 0))
            .ceil()
            .toInt()
        : 0;
  }

//Number of workers(Fully Washed) = (total kg of cherry x by the fully washed percentage ) ÷ 500 kg worker/day
//Number of workers(Natural) = (total kg of cherry x by the natural  percentage ) ÷ 500 kg worker/day

  /// Calculates the number of workers required for the fully washed process.
  ///
  /// Uses cherry input, process split, and standard labor rates.
  /// Assumes 500 kg per worker per day as industry standard.
  int get numberOfWorkersForFullyWashed {
    // Number of workers for fully washed process = (total kg of cherry x fully washed percent) / 500 kg per worker per day
    final calculatedFullyWashedPercent =
        selectedCoffeesellingType.value == 'Parchment' || fullyWashedPercent.value == 1.0 ? 1 : fullyWashedPercent.value;
    return ((cherryAmount * calculatedFullyWashedPercent) / 500).isFinite
        ? ((cherryAmount * calculatedFullyWashedPercent) / 500).ceil()
        : 0;
  }

  /// Calculates the amount of cherry allocated to the fully washed process
  double get fullWashedCherry => cherryAmount * fullyWashedPercent.value;
  
  /// Calculates the number of workers required for the natural process.
  ///
  /// Uses cherry input, process split, and standard labor rates.
  /// Assumes 500 kg per worker per day as industry standard.
  void calculateLaborAndBatches() {
    final cherryBatch = double.tryParse(plannedCherriesPerBatch.text) ?? 0.0;
    laborPerBatch = ceilSafe(cherryBatch / 500);
    batches = ceilSafe(cherryAmount / cherryBatch);
  }



  /// Calculates the total number of bags needed for both washed and natural processes.
  /// This is used for warehouse planning and storage requirements.
  int get wareHousePlanning =>
      numberOfBagsForFullyWashed + numberOfBagsForNatural;

  /// Retrieves the cherry amount based on the selected coffee selling type and conversion factors.
  ///
  /// If the selected type is Cherries, returns the input directly.
  /// Otherwise, converts from the selected type to cherry equivalent using conversion factors.
  double get cherryAmount {
    // Calculate the cherry amount based on selected coffee selling type and conversion factors
    if (selectedCoffeesellingType.value == 'Cherries') {
      return double.tryParse(seasonalCoffeeController.text) ?? 0;
    }
    return (double.tryParse(seasonalCoffeeController.text) ?? 0) /
        (conversionFactors[selectedCoffeesellingType.value] ?? 0);
  }

  /// Calculates the number of fermenting days (round up to nearest day).
  ///
  /// Converts fermenting hours to days and rounds up to ensure sufficient time.
  int get numberOfDaysFermenting {
    // Calculate the number of fermenting days (round up to nearest day)
    final days = getFermentingHours / 24;
    return days.ceil(); // Rounds up to the nearest whole day
  }

  /// Retrieves the fermenting hours from user input
  int get getFermentingHours =>
      int.tryParse(fermentationHoursController.text) ?? 0;
  /// Retrieves the soaking hours from user input
  int get getSoakingHours => int.tryParse(soakingDurationController.text) ?? 0;
  /// Retrieves the dried hours for the washed process from user input
  int get getWashedDryingHours =>
      int.tryParse(dryingTimeWashedController.text) ?? 0;

  /// Retrieves the wet parchment volume from cherry amount using a conversion rate.
  ///
  /// Uses 39% conversion rate from cherry to wet parchment.
  /// This accounts for moisture loss during the pulping process.
  double get getWetParchmentVolume {
    // 39% conversion from cherry to wet parchment
    const conversionRate = 0.39;
    return cherryAmount * conversionRate;
  }

  /// Retrieves the dry parchment volume from cherry amount using a conversion rate.
  ///
  /// Uses 20% conversion rate from cherry to dry parchment.
  /// This represents the final parchment yield after drying.
  double get getDryParchmentVolume {
    // 20% conversion from cherry to dry parchment
    const conversionRate = 0.20;
    return cherryAmount * conversionRate;
  }

  /// Retrieves the dry pod volume from cherry amount using a conversion rate.
  ///
  /// Uses 12% conversion rate from cherry to dry pod.
  /// This represents the natural process yield after drying.
  double get getDryPodVolume {
    // 12% conversion from cherry to dry pod
    const conversionRate = 0.12;
    return cherryAmount * conversionRate;
  }

  /// Calculates the green coffee output from the dry pod volume.
  ///
  /// Dried Pod : Green Coffee = 1.25 : 1, so divide dry pod volume by 1.25
  /// This represents the final green coffee yield from the natural process.
  double get getGreenCoffeeOutput {
    // Dried Pod : Green Coffee = 1.25 : 1, so divide dry pod volume by 1.25
    const double conversionRate = 1.25;
    return getDryPodVolume / conversionRate;
  }

//The system will count from the start date to the end date excluding Sundays and will display the total operating day.
  /// Calculates the total number of operating days, excluding Sundays.
  ///
  /// Uses the selected date range and skips Sundays for realistic scheduling.
  /// This provides a more accurate planning timeline for coffee processing operations.
  int get totalOperatingDays {
    // Calculate the total number of operating days between start and end date, excluding Sundays
    if (startDate.value == null || endDate.value == null) return 0;

    print('START: [38;5;246m [48;5;236m${startDate.value} [0m');
    print('END: [38;5;246m [48;5;236m${endDate.value} [0m');

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

  /// Returns a formatted date range string for display.
  ///
  /// Formats the start and end dates in a user-friendly format for UI display.
  String get dateRangeFormatted {
    if (startDate.value == null || endDate.value == null) return '';
    final formatter = DateFormat('MMM d, yyyy');
    return '${formatter.format(startDate.value!)}  -  ${formatter.format(endDate.value!)}';
  }
  // 0.16 unsorted green coffee conversion factor relative to cherry

  /// Calculates the output value for the washed process based on user selection.
  ///
  /// Updates the washed output value based on the selected coffee selling type.
  /// Uses different conversion factors for Parchment vs other types.
  void calculateWashedOutput() {
    // Calculate washed output value based on selected coffee selling type
    if (selectedCoffeesellingType.value == 'Parchment'|| fullyWashedPercent.value == 1.0) {
      washedOutputValue.value = (cherryAmount * 0.16).toStringAsFixed(2);
    } else {
      washedOutputValue.value =
          (cherryAmount * fullyWashedPercent.value * 0.16).toStringAsFixed(2);
    }
  }

  /// Calculates the output value for the natural process based on user selection.
  ///
  /// Updates the natural output value based on the selected coffee selling type.
  /// Uses different conversion factors for Dried pod/Jenfel vs other types.
  void calculateNaturalOutput() {
    // Calculate natural output value based on selected coffee selling type
    if (selectedCoffeesellingType.value == 'Dried pod/Jenfel' || sunDriedPercent.value == 1) {
      naturalOutputValue.value = (cherryAmount * 0.2).toStringAsFixed(2);
    } else {
      naturalOutputValue.value =
          (cherryAmount * sunDriedPercent.value * 0.2).toStringAsFixed(2);
    }
  }

  /// Updates the output value for the washed process when the user changes the output type.
  ///
  /// Handles conversion between Green Coffee and Parchment output types.
  /// Recalculates the output value based on the new selection.
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
        selectedCoffeesellingType.value == 'Parchment' || fullyWashedPercent.value == 1.0 ? 1 : fullyWashedPercent.value;
    if (value == 'Green Coffee') {
      parsed = cherryAmount * calculatedFullyWashedPercent * 0.16;
    } else {
      parsed = cherryAmount * calculatedFullyWashedPercent * 0.2;
    }

    washedOutputValue.value = parsed.toStringAsFixed(2);
    selectedOutPutValueForWashed.value = value;
  }

  /// Updates the output value for the natural process when the user changes the output type.
  ///
  /// Handles conversion between Green Bean and Dried Pod output types.
  /// Recalculates the output value based on the new selection.
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
        selectedCoffeesellingType.value == 'Dried pod/Jenfel' || sunDriedPercent.value == 1
            ? 1
            : sunDriedPercent.value;
    if (value == 'Green Bean') {
      parsed = cherryAmount * calculatedSunDriedPercent * 0.16;
    } else {
      parsed = cherryAmount * calculatedSunDriedPercent * 0.2;
    }
    naturalOutputValue.value = parsed.toStringAsFixed(2);
    selectedOutPutValueForNatural.value = value;
  }

  /// Navigates to the operational summary view with the current plan data.
  ///
  /// Builds the operational planning data model and passes it to the summary view
  /// for display and further processing.
  void onDataSubmit(BuildContext context) {
      String message = '';
      if (cherryBatch > dailyPulpingCapacity && selectedCoffeesellingType.value !=
                  'Dried pod/Jenfel' && sunDriedPercent.value != 1.0) {
      message = '${'Planned volume per batch exceeds daily pulping capacity. Cherry per batch should be below'.tr}$dailyPulpingCapacity ${'kg'.tr}.';
      showBottleNeckModal(context: context,message: message);
   
    }else  if (cherryBatch < dailyPulpingCapacity  && selectedCoffeesellingType.value !=
                  'Dried pod/Jenfel' && sunDriedPercent.value != 1.0) {
      message =  '${'Planned volume per batch below the daily pulping capacity. To be economical increase cherry per batch up to'.tr}$dailyPulpingCapacity ${'kg'.tr}.';
      showBottleNeckModal(context: context,message: message);  
    }else{
   Get.toNamed<void>(
      AppRoutes.OPERATIONAL_SUMMARY,
      arguments: {
        'data': buildOperationalPlanningData(),
        'isFromTable': false,
      },
    );
    }


   
  }

  /// Loads plans for a specific site from the plan service.
  ///
  /// Updates the sitePlans observable with plans filtered by the given site ID.
  /// This allows users to view and manage site-specific operational plans.
  void loadPlansBySite({required String siteId}) {
    sitePlans.assignAll(
      _planService.getPlansBySite(siteId: siteId),
    );
  }

  /// Saves the current plan to persistent storage using the plan service.
  ///
  /// Builds the operational planning data model and saves it with the provided
  /// site information and plan name. Shows error message if saving fails.
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
  /// Builds the operational planning data model from the current controller state.
  ///
  /// This method collects all user input and calculated values into a single model
  /// for saving or displaying in the summary view. It includes all form data,
  /// calculated capacities, and planning requirements.
  OperationalPlanningModel buildOperationalPlanningData({
    List<Map<String, String>> selectedSites = const [],
    String planName = '',
  }) =>
      OperationalPlanningModel(
        plannedCherriesPerBatch:plannedCherriesPerBatch.text,
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
        numberOfFermentationTank : numberOfFermentationTank.text,
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
        laborPerBatch: laborPerBatch,
        batches: batches,
        selectedSites: selectedSites,

        totalFerCapacityPerCycle: totalFerCapacityPerCycle,
        ferTanksPerBatch:ferTanksPerBatch,
        ferCycleTotal: ferCycleTotal,

        soakingPulpCapacity: soakingPulpCapacity,
        soakCyclesPerBatch: soakCyclesPerBatch, 
        soakingCycleTotal: soakingCycleTotal, 
        totalWashedDryingBeds: totalWashedDryingBeds, 
        totalNatDryingBeds : totalNatDryingBeds,
      );
  
  /// Updates the controller's state with data from a loaded operational planning model.
  ///
  /// This method restores all form fields and calculated values from a saved plan,
  /// allowing users to edit or review previously created plans.
  void patchOperationalPlanningData(OperationalPlanningModel data) {
    startDate.value = data.startDate;
    endDate.value = data.endDate;

    selectedCoffeesellingType.value = data.selectedCoffeeSellingType;

    seasonalCoffeeController.text = data.seasonalCoffee ?? '';
    plannedCherriesPerBatch.text = data.plannedCherriesPerBatch ?? '';
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
    numberOfFermentationTank.text = data.numberOfFermentationTank ?? '';      
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
    laborPerBatch = data.laborPerBatch ?? 0;
    batches = data.batches ?? 0;
    totalFerCapacityPerCycle = data.totalFerCapacityPerCycle ?? 0;
    ferTanksPerBatch = data.ferTanksPerBatch ?? 0;
    ferCycleTotal = data.ferCycleTotal?? 0;
    soakingPulpCapacity = data.soakingPulpCapacity?? 0;
    soakCyclesPerBatch = data.soakCyclesPerBatch?? 0; 
    soakingCycleTotal = data.soakingCycleTotal?? 0; 
    totalWashedDryingBeds = data.totalWashedDryingBeds?? 0; 
    totalNatDryingBeds  = data.totalNatDryingBeds?? 0;
    // cherryAmount = data.cherryAmount ?? 0;
    // getTotalProcessingDaysForWashed = data.processingDaysForWashed ?? 0;
    // getGreenCoffeeOutput = data.greenCoffeeOutput ?? 0;
    // getDryParchmentVolume = data.dryParchmentVolume ?? 0;
    // getDryPodVolume = data.dryPodVolume ?? 0;
    // numberOfWorkersForNatural = data.numberOfWorkersForNatural ?? 0;
    // numberOfWorkersForFullyWashed = data.numberOfWorkersForFullyWashed ?? 0;
  }
  
   Future<T?> showBottleNeckModal<T>({
    required BuildContext context,
    required String message,
  }) =>
      showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => BestPracticeModal(
          title: 'Value Outside Best Practices'.tr,
          message:
              message,
              recommendedRanges: [],
          // recommendedRanges: [
          //   Builder(
          //     builder: (context) => Padding(
          //       padding: const EdgeInsets.only(top: 8, bottom: 12),
          //       child: Text(
          //         'Recommended Range'.tr,
          //         style: Theme.of(context)
          //             .textTheme
          //             .titleMedium
          //             ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
          //       ),
          //     ),
          //   ),
          //   Text.rich(
          //     TextSpan(
          //       children: [
          //         const WidgetSpan(
          //           child: Icon(Icons.circle, size: 4, color: Colors.black54),
          //           alignment: PlaceholderAlignment.middle,
          //         ),
          //         TextSpan(
          //           text:
          //               ' Lump-sum Seasonal Cherry Price: ',
                       
          //           style: const TextStyle(
          //             fontWeight: FontWeight.w400,
          //             fontSize: 12,
          //             color: Color(0xFF717680),
          //           ),
          //         ),
          //         TextSpan(
          //           text: 'ETB  to ETB ',
          //           style: const TextStyle(
          //             fontWeight: FontWeight.w600,
          //             fontSize: 12,
          //             color: Color(0xFF252B37),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          
          // ],
         
          tip:
              'Double-check your input and ensure it aligns with industry best practices for better results.'
                  .tr,
          onContinue: () {
      Get.toNamed<void>(
      AppRoutes.OPERATIONAL_SUMMARY,
      arguments: {
        'data': buildOperationalPlanningData(),
        'isFromTable': false,
      },
    );
          },
          onEdit: () {
            currentStep.value = 0;
            Navigator.pop(context);
           
          },
        ),
      );
   int ceilSafe(double? value) {
    if (value == null || value.isNaN || value.isInfinite) return 0;
    return value.ceil();
  }

  @override
  void onClose() {
    controller.selectedSite = [];
    super.dispose();
  }
}
