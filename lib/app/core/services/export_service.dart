import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/config/app_assets.dart';
import 'package:flutter_template/app/core/services/calculation_service.dart';
import 'package:flutter_template/app/core/services/wet_mill_service.dart';
import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:flutter_template/app/data/models/save_breakdown_model.dart';
import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:flutter_template/app/utils/bottom_sheet_loader.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

/// Exports saved breakdowns to an Excel file.
Future<void> exportSavedBreakdownsToExcel({
  required double breakEvenPrice,
  required bool isBestPractice,
  required List<SiteInfo> sites,
  required BuildContext context,
  BasicCalculationEntryModel? basicCalcData,
  AdvancedCalculationModel? advancedCalcData,
}) async {
  if (!await _requestStoragePermission()) {
    return;
  }

  final excel = Excel.createExcel();

  // Create sheet with custom sheet name
  final sheet = excel['Breakdowns'];
  final now = DateFormat('MMM d, yyyy').format(DateTime.now());

  // Remove the default sheet (usually named 'Sheet1')
  excel.delete('Sheet1');
  // Add headers
  // Define headers and row dynamically
  final List<CellValue> headers = [
    TextCellValue('Break Even Price'),
  ];

  final List<CellValue> data = [
    DoubleCellValue(breakEvenPrice),
  ];

  if (basicCalcData != null) {
    headers.addAll([
      TextCellValue('Selling Type'),
      TextCellValue('Expected Profit'),
      TextCellValue('Purchase Volume '),
      TextCellValue('Seasonal Price'),
      TextCellValue('Fuel & Oils'),
      TextCellValue('Cherry Transport'),
      TextCellValue('Labor Full Time'),
      TextCellValue('Labor Casual'),
      TextCellValue('Repairs & Maintenance'),
      TextCellValue('Other Expenses'),
      TextCellValue('Ratio'),
      TextCellValue('Total Selling Price'),
    ]);

    data.addAll([
      TextCellValue(basicCalcData.sellingType),
      TextCellValue(basicCalcData.expectedProfit),
      TextCellValue(basicCalcData.purchaseVolume),
      TextCellValue(basicCalcData.seasonalPrice),
      TextCellValue(basicCalcData.fuelAndOils),
      TextCellValue(basicCalcData.cherryTransport),
      TextCellValue(basicCalcData.laborFullTime),
      TextCellValue(basicCalcData.laborCasual),
      TextCellValue(basicCalcData.repairsAndMaintenance),
      TextCellValue(basicCalcData.otherExpenses),
      TextCellValue(basicCalcData.ratio),
      TextCellValue(basicCalcData.totalSellingPrice.toStringAsFixed(2)),
    ]);
  } else if (advancedCalcData != null) {
    headers.addAll([
      TextCellValue('Selling Type'),
      TextCellValue('Cherry Purchase'),
      TextCellValue('Seasonal Coffee'),
      TextCellValue('Second Payment'),
      TextCellValue('Low Grade Hulling'),
      TextCellValue('Jute Bag Price'),
      TextCellValue('Jute Bag Volume'),
      TextCellValue('Ratio'),
      TextCellValue('Procurement Total'),
      //transport
      TextCellValue('Transport Cost'),
      TextCellValue('Commission'),
      TextCellValue('Transport Total'),
      //labour
      TextCellValue('Casual Labour'),
      TextCellValue('Permanenet Labour'),
      TextCellValue('Overhead'),
      TextCellValue('Other Labour'),
      TextCellValue('Permanent Total'),
      TextCellValue('Casual Total'),
      //fuel
      TextCellValue('Fuel Cost'),
      TextCellValue('Fuel Total'),
      //maintenanace
      TextCellValue('Utilities'),
      TextCellValue('Annual Maintenance Cost'),
      TextCellValue('Drying Bed Equipment'),
      TextCellValue('Spare Part Cost'),
      TextCellValue('Maintenance Total'),
      //other exppenses
      TextCellValue('Other Expenses'),
      TextCellValue('Other Total'),

      //
      TextCellValue('Jute Bag Total'),
      TextCellValue('Variable Cost'),
    ]);

    data.addAll([
      TextCellValue(advancedCalcData.sellingType),
      TextCellValue(advancedCalcData.cherryPurchase),
      TextCellValue(advancedCalcData.seasonalCoffee),
      TextCellValue(advancedCalcData.secondPayment),
      TextCellValue(advancedCalcData.lowGradeHulling),
      TextCellValue(advancedCalcData.juteBagPrice),
      TextCellValue(advancedCalcData.juteBagVolume),
      TextCellValue(advancedCalcData.ratio),
      TextCellValue(advancedCalcData.procurementTotal.toStringAsFixed(2)),
      //transport
      TextCellValue(advancedCalcData.transportCost),
      TextCellValue(advancedCalcData.commission),
      TextCellValue(advancedCalcData.transportTotal.toStringAsFixed(2)),
      //labour
      TextCellValue(advancedCalcData.casualLabour),
      TextCellValue(advancedCalcData.permanentLabour),
      TextCellValue(advancedCalcData.overhead),
      TextCellValue(advancedCalcData.otherLabour),
      TextCellValue(advancedCalcData.permanentTotal.toStringAsFixed(2)),
      TextCellValue(advancedCalcData.casualTotal.toStringAsFixed(2)),
      //fuel
      TextCellValue(advancedCalcData.fuelCost),
      TextCellValue(advancedCalcData.fuelTotal.toStringAsFixed(2)),
      //maintenance
      TextCellValue(advancedCalcData.utilities),
      TextCellValue(advancedCalcData.annualMaintenance),
      TextCellValue(advancedCalcData.dryingBed),
      TextCellValue(advancedCalcData.sparePart),
      TextCellValue(advancedCalcData.maintenanceTotal.toStringAsFixed(2)),
      //other
      TextCellValue(advancedCalcData.otherExpenses),

      TextCellValue(advancedCalcData.otherTotal.toStringAsFixed(2)),
      //total
      TextCellValue(advancedCalcData.jutBagTotal.toStringAsFixed(2)),
      TextCellValue(advancedCalcData.variableCostTotal.toStringAsFixed(2)),
    ]);
  }
  appendExtrasInline(
    prefix: 'procurement',
    extras: advancedCalcData?.procurementExtras,
    headersTarget: headers,
    dataTarget: data,
  );
  appendExtrasInline(
    prefix: 'transport',
    extras: advancedCalcData?.transportExtras,
    headersTarget: headers,
    dataTarget: data,
  );
  appendExtrasInline(
    prefix: 'fuel',
    extras: advancedCalcData?.fuelExtras,
    headersTarget: headers,
    dataTarget: data,
  );
  appendExtrasInline(
    prefix: 'maintenance',
    extras: advancedCalcData?.maintenanceExtras,
    headersTarget: headers,
    dataTarget: data,
  );
  appendExtrasInline(
    prefix: 'other',
    extras: advancedCalcData?.otherExtras,
    headersTarget: headers,
    dataTarget: data,
  );
  headers.addAll([
    TextCellValue('Best Practice'),
    TextCellValue('Created At'),
    TextCellValue('Type'),
  ]);
  data.addAll([
    TextCellValue(isBestPractice ? 'Best Practice' : 'Below Market'),
    TextCellValue(now),
    TextCellValue(basicCalcData != null ? 'Basic' : 'Advanced'),
  ]);

// Append to sheet
  sheet.appendRow(headers);
  sheet.appendRow(data);

// Spacer
  sheet.appendRow([TextCellValue('')]);

  // Site Info Section Header
  sheet.appendRow([TextCellValue('Site Info')]);

  // Site Info Column Headers
  sheet.appendRow([
    TextCellValue('Coffee Washing Station'),
    TextCellValue('Location'),
    TextCellValue('Business Model'),
    TextCellValue('Processing Capacity'),
    TextCellValue('Storage Space'),
    TextCellValue('Drying Beds'),
    TextCellValue('Fermentation Tanks'),
    TextCellValue('Pulping Machine Capacity '),
    TextCellValue('Workers'),
    TextCellValue('Farmers'),
    TextCellValue('Created At'),
  ]);

  // Site Info Data Rows
  for (final site in sites) {
    sheet.appendRow([
      TextCellValue(site.siteName),
      TextCellValue(site.location),
      TextCellValue(site.businessModel),
      IntCellValue(site.processingCapacity),
      IntCellValue(site.storageSpace),
      IntCellValue(site.dryingBeds),
      IntCellValue(site.fermentationTanks),
      IntCellValue(site.pulpingCapacity),
      IntCellValue(site.workers),
      IntCellValue(site.farmers),
      TextCellValue(DateFormat('MMM d, yyyy').format(site.createdAt)),
    ]);
  }

// Create temp file
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final tempDir = await getTemporaryDirectory();
  final tempFilePath = '${tempDir.path}/saved_breakdowns_$timestamp.xlsx';

  final fileBytes = excel.encode();
  if (fileBytes == null) throw Exception('Failed to generate Excel');

  final tempFile = File(tempFilePath);
  await tempFile.writeAsBytes(fileBytes);

  // Save to Downloads folder
  try {
    // For Android
    final downloadsDir = Directory('/storage/emulated/0/Download');

    // Create directory if it doesn't exist
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }

    final savePath = '${downloadsDir.path}/saved_breakdowns_$timestamp.xlsx';
    await tempFile.copy(savePath);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('File saved successfully!'),
        action: SnackBarAction(
          label: 'OPEN FILE',
          onPressed: () async {
            try {
              await OpenFile.open(
                savePath,
                type:
                    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cannot open file: ${e.toString()}')),
              );
            }
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  } catch (e) {
    try {
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        final savePath = '${externalDir.path}/saved_breakdowns_$timestamp.xlsx';
        await tempFile.copy(savePath);
      }
    } catch (e) {
      rethrow;
    }
  }
}

/// Appends extra data inline to the headers and data lists.
void appendExtrasInline({
  required String prefix,
  required List<Map<String, String>>? extras,
  required List<CellValue> headersTarget,
  required List<CellValue> dataTarget,
}) {
  if (extras == null) {
    return;
  }
  for (final extra in extras) {
    if (extra.isNotEmpty) {
      final key = extra.keys.first;
      final value = extra[key] ?? '';
      headersTarget.add(TextCellValue('$prefix:$key'));
      dataTarget.add(TextCellValue(value));
    }
  }
}

/// Exports saved breakdowns to a PDF file.
Future<void> exportSavedBreakdownsToPdf({
  required double breakEvenPrice,
  required bool isBestPractice,
  required List<SiteInfo> sites,
  required BuildContext context,
  BasicCalculationEntryModel? basicCalcData,
  AdvancedCalculationModel? advancedCalcData,
}) async {
  if (!await _requestStoragePermission()) return;

  final pdf = pw.Document();
  final now = DateFormat('MMM d, yyyy').format(DateTime.now());

  pdf.addPage(
    pw.MultiPage(
      orientation: pw.PageOrientation.landscape,
      build: (pw.Context context) {
        final List<String> headers = ['Break Even Price'];
        final List<String> data = [breakEvenPrice.toStringAsFixed(2)];

        if (basicCalcData != null) {
          headers.addAll([
            'Selling Type',
            'Expected Profit',
            'Purchase Volume',
            'Seasonal Price',
            'Fuel & Oils',
            'Cherry Transport',
            'Labor Full Time',
            'Labor Casual',
            'Repairs & Maintenance',
            'Other Expenses',
            'Ratio',
            'Total Selling Price',
          ]);

          data.addAll([
            basicCalcData.sellingType,
            basicCalcData.expectedProfit,
            basicCalcData.purchaseVolume,
            basicCalcData.seasonalPrice,
            basicCalcData.fuelAndOils,
            basicCalcData.cherryTransport,
            basicCalcData.laborFullTime,
            basicCalcData.laborCasual,
            basicCalcData.repairsAndMaintenance,
            basicCalcData.otherExpenses,
            basicCalcData.ratio,
            basicCalcData.totalSellingPrice.toStringAsFixed(2),
          ]);
        } else if (advancedCalcData != null) {
          headers.addAll([
            'Selling Type',
            'Cherry Purchase',
            'Seasonal Coffee',
            'Second Payment',
            'Low Grade Hulling',
            'Jute Bag Price',
            'Jute Bag Volume',
            'Ratio',
            'Procurement Total',
            'Transport Cost',
            'Commission',
            'Transport Total',
            'Casual Labour',
            'Permanent Labour',
            'Overhead',
            'Other Labour',
            'Permanent Total',
            'Casual Total',
            'Fuel Cost',
            'Fuel Total',
            'Utilities',
            'Annual Maintenance Cost',
            'Drying Bed Equipment',
            'Spare Part Cost',
            'Maintenance Total',
            'Other Expenses',
            'Other Total',
            'Jute Bag Total',
            'Variable Cost',
          ]);

          data.addAll([
            advancedCalcData.sellingType,
            advancedCalcData.cherryPurchase,
            advancedCalcData.seasonalCoffee,
            advancedCalcData.secondPayment,
            advancedCalcData.lowGradeHulling,
            advancedCalcData.juteBagPrice,
            advancedCalcData.juteBagVolume,
            advancedCalcData.ratio,
            advancedCalcData.procurementTotal.toStringAsFixed(2),
            advancedCalcData.transportCost,
            advancedCalcData.commission,
            advancedCalcData.transportTotal.toStringAsFixed(2),
            advancedCalcData.casualLabour,
            advancedCalcData.permanentLabour,
            advancedCalcData.overhead,
            advancedCalcData.otherLabour,
            advancedCalcData.permanentTotal.toStringAsFixed(2),
            advancedCalcData.casualTotal.toStringAsFixed(2),
            advancedCalcData.fuelCost,
            advancedCalcData.fuelTotal.toStringAsFixed(2),
            advancedCalcData.utilities,
            advancedCalcData.annualMaintenance,
            advancedCalcData.dryingBed,
            advancedCalcData.sparePart,
            advancedCalcData.maintenanceTotal.toStringAsFixed(2),
            advancedCalcData.otherExpenses,
            advancedCalcData.otherTotal.toStringAsFixed(2),
            advancedCalcData.jutBagTotal.toStringAsFixed(2),
            advancedCalcData.variableCostTotal.toStringAsFixed(2),
          ]);
        }

        headers.addAll(['Best Practice', 'Created At']);
        data.addAll([
          isBestPractice ? 'Best Practice' : 'Below Market',
          now,
        ]);

        return [
          pw.Text(
            'Breakdown Summary',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: headers,
            data: [data],
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            'Site Info',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.Table.fromTextArray(
            headers: [
              'Coffee Washing Station',
              'Location',
              'Business Model',
              'Cherry processing capacity',
              'Storage Space',
              'Drying Beds',
              'Fermentation Tanks',
              'Pulping Machine Capacity',
              'Workers',
              'Farmers',
              'Created At',
            ],
            data: sites
                .map((site) => [
                      site.siteName,
                      site.location,
                      site.businessModel,
                      site.processingCapacity.toString(),
                      site.storageSpace.toString(),
                      site.dryingBeds.toString(),
                      site.fermentationTanks.toString(),
                      site.pulpingCapacity.toString(),
                      site.workers.toString(),
                      site.farmers.toString(),
                      DateFormat('MMM d, yyyy').format(site.createdAt),
                    ])
                .toList(),
          ),
        ];
      },
    ),
  );

  try {
    final pdfBytes = await pdf.save();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'saved_breakdowns_$timestamp.pdf';

    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/$fileName';
    final tempFile = File(tempPath);
    await tempFile.writeAsBytes(pdfBytes);

    const downloadsPath = '/storage/emulated/0/Download';
    final publicPath = '$downloadsPath/$fileName';

    final downloadsDir = Directory(downloadsPath);
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }

    await tempFile.copy(publicPath);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('File saved successfully!'),
        action: SnackBarAction(
          label: 'OPEN FILE',
          onPressed: () async {
            final file = File(publicPath);
            if (await file.exists()) {
              await OpenFile.open(publicPath, type: 'application/pdf');
            }
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  } catch (e) {
    rethrow;
  }
}

/// Requests storage permission from the user.
Future<bool> _requestStoragePermission() async {
  if (await Permission.manageExternalStorage.isGranted) {
    return true;
  }

  if (Platform.isAndroid) {
    // Android 13+ requires MANAGE_EXTERNAL_STORAGE for Downloads access
    final status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  } else {
    // For older Android/iOS, use standard storage permission
    final status = await Permission.storage.request();
    return status.isGranted;
  }
}

/// Imports an Excel file and saves its data to Hive.
Future<void> importExcelAndSaveToHive({
  required String title,
  required ResultsOverviewType type,
  required String filePath,
  required BuildContext context,
}) async {
  final SiteService siteService = SiteService();
  final CalculationService calculationService = CalculationService();
  BasicCalculationEntryModel? basicCalcData;
  AdvancedCalculationModel? advancedCalcData;
  final extrasMap = {
    'procurement': <Map<String, String>>[],
    'transport': <Map<String, String>>[],
    'fuel': <Map<String, String>>[],
    'maintenance': <Map<String, String>>[],
    'other': <Map<String, String>>[],
  };

  final fileBytes = File(filePath).readAsBytesSync();
  final excel = Excel.decodeBytes(fileBytes);
  final sheet = excel['Breakdowns'];
  if (sheet.rows.length < 2) return;
  final headerRow = sheet.rows[0];
  final breakdownRow = sheet.rows[1];

  // Parse extras from headers and data
  for (int i = 0; i < headerRow.length; i++) {
    final header = headerRow[i]?.value.toString() ?? '';
    if (header.contains(':')) {
      final parts = header.split(':');
      if (parts.length == 2) {
        final prefix = parts[0];
        final key = parts[1];
        final value = breakdownRow[i]?.value.toString() ?? '';

        if (extrasMap.containsKey(prefix)) {
          extrasMap[prefix]!.add({key: value});
        }
      }
    }
  }
  final String excelCalcType =
      breakdownRow[sheet.rows[0].length - 1]?.value.toString() ?? '';

  //check if the given excel calcualtaion type is matched with the selected calaculation type
  if (excelCalcType.trim().toLowerCase() != type.name.trim().toLowerCase()) {
    final bottomSheetContext = Navigator.of(context).overlay!.context;
    await Helpers().showBottomSheet(
        key: Key('bottom'),
        // ignore: use_build_context_synchronously
        bottomSheetContext,
        title: 'Invalid Type',
        subTitle:
            'Please upload the correct excel format or check the calculation type!',
        buttonText: 'OK',
        imagePath: AppAssets.warningIcon,
        isCenteredSubtitle: true, onButtonPressed: () {
      Navigator.of(context).pop(); // Pops only the top sheet
    });

    return;
  }
  if (type == ResultsOverviewType.basic) {
    basicCalcData = BasicCalculationEntryModel(
      totalSellingPrice:
          double.tryParse(breakdownRow[12]?.value.toString() ?? '') ?? 0,
      sellingType: breakdownRow[1]?.value.toString() ?? '',
      expectedProfit: breakdownRow[2]?.value.toString() ?? '',
      purchaseVolume: breakdownRow[3]?.value.toString() ?? '',
      seasonalPrice: breakdownRow[4]?.value.toString() ?? '',
      fuelAndOils: breakdownRow[5]?.value.toString() ?? '',
      cherryTransport: breakdownRow[6]?.value.toString() ?? '',
      laborFullTime: breakdownRow[7]?.value.toString() ?? '',
      laborCasual: breakdownRow[8]?.value.toString() ?? '',
      repairsAndMaintenance: breakdownRow[9]?.value.toString() ?? '',
      otherExpenses: breakdownRow[10]?.value.toString() ?? '',
      ratio: breakdownRow[11]?.value.toString() ?? '',
    );
  } else if (type == ResultsOverviewType.advanced) {
    advancedCalcData = AdvancedCalculationModel(
      sellingType: breakdownRow[1]?.value.toString() ?? '',
      cherryPurchase: breakdownRow[2]?.value.toString() ?? '',
      seasonalCoffee: breakdownRow[3]?.value.toString() ?? '',
      secondPayment: breakdownRow[4]?.value.toString() ?? '',
      lowGradeHulling: breakdownRow[5]?.value.toString() ?? '',
      juteBagPrice: breakdownRow[6]?.value.toString() ?? '',
      juteBagVolume: breakdownRow[7]?.value.toString() ?? '',
      ratio: breakdownRow[8]?.value.toString() ?? '',
      procurementTotal:
          double.tryParse(breakdownRow[9]?.value.toString() ?? '') ?? 0,
      transportCost: breakdownRow[10]?.value.toString() ?? '',
      commission: breakdownRow[11]?.value.toString() ?? '',
      transportTotal:
          double.tryParse(breakdownRow[12]?.value.toString() ?? '') ?? 0,
      casualLabour: breakdownRow[13]?.value.toString() ?? '',
      permanentLabour: breakdownRow[14]?.value.toString() ?? '',
      overhead: breakdownRow[15]?.value.toString() ?? '',
      otherLabour: breakdownRow[16]?.value.toString() ?? '',
      permanentTotal:
          double.tryParse(breakdownRow[17]?.value.toString() ?? '') ?? 0,
      casualTotal:
          double.tryParse(breakdownRow[18]?.value.toString() ?? '') ?? 0,
      fuelCost: breakdownRow[19]?.value.toString() ?? '',
      fuelTotal: double.tryParse(breakdownRow[20]?.value.toString() ?? '') ?? 0,
      utilities: breakdownRow[21]?.value.toString() ?? '',
      annualMaintenance: breakdownRow[22]?.value.toString() ?? '',
      dryingBed: breakdownRow[23]?.value.toString() ?? '',
      sparePart: breakdownRow[24]?.value.toString() ?? '',
      maintenanceTotal:
          double.tryParse(breakdownRow[25]?.value.toString() ?? '') ?? 0,
      otherExpenses: breakdownRow[26]?.value.toString() ?? '',
      otherTotal:
          double.tryParse(breakdownRow[27]?.value.toString() ?? '') ?? 0,
      jutBagTotal:
          double.tryParse(breakdownRow[28]?.value.toString() ?? '') ?? 0,
      variableCostTotal:
          double.tryParse(breakdownRow[29]?.value.toString() ?? '') ?? 0,
      procurementExtras: extrasMap['procurement']!,
      transportExtras: extrasMap['transport']!,
      fuelExtras: extrasMap['fuel']!,
      maintenanceExtras: extrasMap['maintenance']!,
      otherExtras: extrasMap['other']!,
    );
  }

  final breakEvenPrice =
      double.tryParse(breakdownRow[0]?.value.toString() ?? '') ?? 0;

  // Locate the Site Info Section
  final List<Map<String, String>> selectedSites = [];

  final siteHeaderIndex = sheet.rows.indexWhere(
    (row) => row.any((cell) => cell?.value.toString().trim() == 'Site Info'),
  );

  if (siteHeaderIndex != -1 && siteHeaderIndex + 2 <= sheet.rows.length) {
    for (int i = siteHeaderIndex + 2; i < sheet.rows.length; i++) {
      final row = sheet.rows[i];
      if (row.isEmpty || row[0] == null) continue;

      final site = SiteInfo(
        siteName: row[0]?.value.toString() ?? '',
        location: row[1]?.value.toString() ?? '',
        businessModel: row[2]?.value.toString() ?? '',
        processingCapacity: int.tryParse(row[3]?.value.toString() ?? '') ?? 0,
        storageSpace: int.tryParse(row[4]?.value.toString() ?? '') ?? 0,
        dryingBeds: int.tryParse(row[5]?.value.toString() ?? '') ?? 0,
        fermentationTanks: int.tryParse(row[6]?.value.toString() ?? '') ?? 0,
        pulpingCapacity: int.tryParse(row[7]?.value.toString() ?? '') ?? 0,
        workers: int.tryParse(row[8]?.value.toString() ?? '') ?? 0,
        farmers: int.tryParse(row[9]?.value.toString() ?? '') ?? 0,
      );
      bool success = false;
      String title = '';
      String subTitle = '';
      bool isLimitReached = false;
      try {
        success = await siteService.addSite(site);
        if (success) {
          selectedSites.add({
            'siteId': site.id,
            'siteName': site.siteName,
          });
        }
      } catch (e) {
        if (e.toString().contains('DUPLICATE_NAME')) {
          title = 'Duplicate Coffee Washing Station';
          subTitle =
              'A site with this name already exists. Please choose a different name';
        } else if (e.toString().contains('LIMIT_REACHED')) {
          title = 'You can\'t add any more sites';
          subTitle =
              'The system has reached its limit for adding new sites. Delete previous sites to add new sites.';
          isLimitReached = true;
        } else {
          title = 'Unexpected Error';
          subTitle =
              'An error occurred while adding the site. Please try again.';
        }
      }
      if (!success) {
        await Helpers().showBottomSheet(
          // ignore: use_build_context_synchronously
          context,
          title: title,
          subTitle: subTitle,
          buttonText: 'OK',
          imagePath: AppAssets.warningIcon,
          isCenteredSubtitle: true,
          onButtonPressed: () {
            Navigator.of(context).pop();
          },
        );
        return;
      }
    }
  }

  final savedModel = SavedBreakdownModel(
    title: title,
    type: type,
    basicCalculation: basicCalcData,
    advancedCalculation: advancedCalcData,
    breakEvenPrice: breakEvenPrice,
    selectedSites: selectedSites,
    isBestPractice:
        breakdownRow[13]?.value.toString() == 'Best Practice' ? true : false,
  );

  await calculationService.saveBreakdown(savedModel);
  Navigator.of(context).pop();
}
