import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/advanced_calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/basic_calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/file_upload_box.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_dropdown.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/save_cost_breakdown_sheet.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/core/services/export_service.dart';
import 'package:flutter_template/app/data/models/advanced_calculation_model.dart';
import 'package:flutter_template/app/data/models/basic_calculation_entry_model.dart';
import 'package:flutter_template/app/data/models/results_overview_type.dart';
import 'package:get/get.dart';

class UploadCalculationBottomSheet extends StatefulWidget {
final VoidCallback? onUploadComplete;

  const UploadCalculationBottomSheet({super.key, this.onUploadComplete});

  @override
  State<UploadCalculationBottomSheet> createState() =>
      _UploadCalculationBottomSheetState();
}

class _UploadCalculationBottomSheetState
    extends State<UploadCalculationBottomSheet> {
  String? slectedCalculationType;
  final sites = ['Basic Calculator', 'Advanced Calculator'];
  final TextEditingController titleController = TextEditingController();
  PlatformFile? pickedFile;

  bool isUploaded = false;
  bool isUploading = false;
  double uploadProgress = 0.0;
  String fileName = 'File name.pdf';
  String fileSize = '250Kb';
  bool showTitleError = false;
  bool showCalculationTypeError = false;
  void _startUpload() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    setState(() {
      isUploading = true;
      uploadProgress = 0.0;
    });
    // Simulate upload progress
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          uploadProgress = 75.0;
        });
      }
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          isUploading = false;
          isUploaded = true;
        });
      });
    });
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        pickedFile = result.files.first;
        fileName = pickedFile!.name;
        fileSize = '${(pickedFile!.size / 1024).toStringAsFixed(0)}Kb';
        isUploaded = true;
      });
    }
  }

  void _resetUpload() {
    setState(() {
      isUploaded = false;
      isUploading = false;
      pickedFile = null;
      uploadProgress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final calcController = Get.put(CalculatorController());

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top drag handle
            Center(
              child: Container(
                width: 60,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Text(
              'Upload Calculation Data'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF23262F),
              ),
            ),
            const SizedBox(height: 24),
            // Calculation Type Dropdown
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Calculation Type'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF23262F),
                ),
              ),
            ),
            LabeledDropdown<String>(
              label: '',
              hintText: 'Select Calculation Type'.tr,
              items: sites
                  .map(
                    (site) => DropdownMenuItem(
                      value: site,
                      child: Text(site.tr),
                    ),
                  )
                  .toList(),
              value: slectedCalculationType,
              onChanged: (val) => setState(() => slectedCalculationType = val),
            ),
            if (showCalculationTypeError)
              const SizedBox(
                height: 8,
              ),
            if (showCalculationTypeError)
              Text(
                "Calculation type shouldn't be empty".tr,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.error70,
                    ),
              ),

            const SizedBox(height: 20),
            // Save as TextField
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Save as'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF23262F),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              onChanged: (value) {
                if (titleController.text.isEmpty) {
                  setState(() => showTitleError = true);
                } else {
                  setState(() => showTitleError = false);
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter title'.tr,
                hintStyle: const TextStyle(
                  color: Color(0xFFB0B7C3),
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE6E8EC)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE6E8EC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFB0B7C3)),
                ),
              ),
            ),
            if (showTitleError)
              const SizedBox(
                height: 8,
              ),
            if (showTitleError)
              Text(
                "Title shouldn't be empty".tr,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.error70,
                    ),
              ),
            const SizedBox(height: 20),
            // File Upload Box
            FileUploadBox(
              isUploaded: isUploaded,
              isUploading: isUploading,
              uploadProgress: uploadProgress,
              fileName: fileName,
              fileSize: fileSize,
              fileIconPath: 'assets/images/xl.png',
              onBrowse: _startUpload,
              onDelete: _resetUpload,
            ),
            const SizedBox(height: 28),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFF8F9FB),
                        side: const BorderSide(color: Color(0xFFF8F9FB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      child: Text(
                        'Cancel'.tr,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: pickedFile == null
                          ? null
                          : () async {
                              if (titleController.isBlank) {
                                setState(() => showTitleError = true);
                              } else if (slectedCalculationType == null) {
                                setState(() => showCalculationTypeError = true);
                              } else {
                             try {
  final importedModel = await importExcelAndSaveToHive(
    filePath: pickedFile!.path!,
    title: titleController.text,
    type: slectedCalculationType == 'Basic Calculator'
        ? ResultsOverviewType.basic
        : ResultsOverviewType.advanced,
    context: context,
  );

  // Reload saved calculations
  calcController.loadSavedCalcuations();
if (importedModel != null) {
  setState(() {
    if (importedModel is BasicCalculationEntryModel) {
      final basicController = Get.find<BasicCalculatorController>(); // Retrieve the existing instance
      basicController.patchPreviousData(data: importedModel);
    } else if (importedModel is AdvancedCalculationModel) {
      final advancedController = Get.find<AdvancedCalculatorController>(); // Retrieve the existing instance
      advancedController.patchAdvancedCalcData(data: importedModel);
    }
  });
}
widget.onUploadComplete?.call();
  // Now use the returned model

} catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${e.toString()}'),
                                    ),
                                  );
                                  setState(() {
                                    isUploading = false;
                                    isUploaded = false;
                                  });
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF11696D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      child: Text(
                        'Upload'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
