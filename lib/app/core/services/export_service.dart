import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> exportSavedBreakdownsToExcel({
  required double breakEvenPrice,
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
  sheet.appendRow([
    TextCellValue('Break Even Price'),
    TextCellValue('Selling Type'),
    TextCellValue('Expected Profit'),
    TextCellValue('Purchase Volume'),
    TextCellValue('Seasonal Price'),
    TextCellValue('Fuel & Oils'),
    TextCellValue('Cherry Transport'),
    TextCellValue('Labor Full Time'),
    TextCellValue('Labor Casual'),
    TextCellValue('Repairs & Maintenance'),
    TextCellValue('Other Expenses'),
    TextCellValue('Ratio'),
    TextCellValue('Created At'),
  ]);

  sheet.appendRow([
    DoubleCellValue(breakEvenPrice),
    TextCellValue(basicCalcData?.sellingType ?? 'not available'),
    TextCellValue(basicCalcData?.expectedProfit ?? 'not avaialbe'),
    TextCellValue(
      basicCalcData?.purchaseVolume ?? advancedCalcData?.cherryPurchase ?? '',
    ),
    TextCellValue(
      basicCalcData?.seasonalPrice ?? advancedCalcData?.seasonalCoffee ?? '',
    ),
    TextCellValue(
      basicCalcData?.fuelAndOils ??
          advancedCalcData?.fuelTotal.toStringAsFixed(2) ??
          '',
    ),
    TextCellValue(
      basicCalcData?.cherryTransport ??
          advancedCalcData?.transportTotal.toStringAsFixed(2) ??
          '',
    ),
    TextCellValue(
      basicCalcData?.laborFullTime ??
          advancedCalcData?.permanentTotal.toStringAsFixed(2) ??
          '',
    ),
    TextCellValue(
      basicCalcData?.laborCasual ??
          advancedCalcData?.casualTotal.toStringAsFixed(2) ??
          '',
    ),
    TextCellValue(
      basicCalcData?.repairsAndMaintenance ??
          advancedCalcData?.maintenanceTotal.toStringAsFixed(2) ??
          '',
    ),
    TextCellValue(
      basicCalcData?.otherExpenses ??
          advancedCalcData?.otherTotal.toStringAsFixed(2) ??
          '',
    ),
    TextCellValue(basicCalcData?.ratio ?? advancedCalcData?.ratio ?? ''),
    TextCellValue(now),
  ]);
// Spacer
  sheet.appendRow([TextCellValue('')]);

  // Site Info Section Header
  sheet.appendRow([TextCellValue('Site Info')]);

  // Site Info Column Headers
  sheet.appendRow([
    TextCellValue('Site Name'),
    TextCellValue('Location'),
    TextCellValue('Business Model'),
    TextCellValue('Processing Capacity'),
    TextCellValue('Storage Space'),
    TextCellValue('Drying Beds'),
    TextCellValue('Fermentation Tanks'),
    TextCellValue('Pulping Capacity'),
    TextCellValue('Workers'),
    TextCellValue('Farmers'),
    TextCellValue('Water Consumption'),
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
      IntCellValue(site.waterConsumption),
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

Future<void> exportSavedBreakdownsToPdf({
  required double breakEvenPrice,
  required List<SiteInfo> sites,
  required BuildContext context,
  BasicCalculationEntryModel? basicCalcData,
  AdvancedCalculationModel? advancedCalcData,
}) async {
  if (!await _requestStoragePermission()) {
    return;
  }

  final pdf = pw.Document();
  final now = DateFormat('MMM d, yyyy').format(DateTime.now());

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Breakdown Summary',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: [
              'Break Even Price',
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
              'Created At',
            ],
            data: [
              [
                breakEvenPrice.toStringAsFixed(2),
                basicCalcData?.sellingType ?? 'not available',
                basicCalcData?.expectedProfit ?? 'not avaialbe',
                basicCalcData?.purchaseVolume ??
                    advancedCalcData?.cherryPurchase ??
                    '',
                basicCalcData?.seasonalPrice ??
                    advancedCalcData?.seasonalCoffee ??
                    '',
                basicCalcData?.fuelAndOils ??
                    advancedCalcData?.fuelTotal.toStringAsFixed(2) ??
                    '',
                basicCalcData?.cherryTransport ??
                    advancedCalcData?.transportTotal.toStringAsFixed(2) ??
                    '',
                basicCalcData?.laborFullTime ??
                    advancedCalcData?.permanentTotal.toStringAsFixed(2) ??
                    '',
                basicCalcData?.laborCasual ??
                    advancedCalcData?.casualTotal.toStringAsFixed(2) ??
                    '',
                basicCalcData?.repairsAndMaintenance ??
                    advancedCalcData?.maintenanceTotal.toStringAsFixed(2) ??
                    '',
                basicCalcData?.otherExpenses ??
                    advancedCalcData?.otherTotal.toStringAsFixed(2) ??
                    '',
                basicCalcData?.ratio ?? advancedCalcData?.ratio ?? '',
                now,
              ]
            ],
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            'Site Info',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.Table.fromTextArray(
            headers: [
              'Site Name',
              'Location',
              'Business Model',
              'Processing Capacity',
              'Storage Space',
              'Drying Beds',
              'Fermentation Tanks',
              'Pulping Capacity',
              'Workers',
              'Farmers',
              'Water Consumption',
              'Created At',
            ],
            data: sites
                .map(
                  (site) => [
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
                    site.waterConsumption.toString(),
                    DateFormat('MMM d, yyyy').format(site.createdAt),
                  ],
                )
                .toList(),
          ),
        ],
      ),
    ),
  );

  try {
    // 1. Generate the PDF
    final pdfBytes = await pdf.save();

    // 2. Create file name with timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'saved_breakdowns_$timestamp.pdf';

    // 3. Create temporary file
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/$fileName';
    final tempFile = File(tempPath);
    await tempFile.writeAsBytes(pdfBytes);

    // 4. Define downloads path
    const downloadsPath = '/storage/emulated/0/Download';
    final publicPath = '$downloadsPath/$fileName';

    // 5. Ensure downloads directory exists
    final downloadsDir = Directory(downloadsPath);
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }

    // 6. Copy file to downloads directory
    await tempFile.copy(publicPath);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('File saved successfully!'),
        action: SnackBarAction(
          label: 'OPEN FILE',
          onPressed: () async {
            // Open the downloads folder
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
