import 'package:flutter/material.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/file_upload_box.dart';
import 'package:flutter_template/app/Pages/calculator/widgets/labeled_dropdown.dart';

class UploadCalculationBottomSheet extends StatefulWidget {
  const UploadCalculationBottomSheet({super.key});

  @override
  State<UploadCalculationBottomSheet> createState() =>
      _UploadCalculationBottomSheetState();
}

class _UploadCalculationBottomSheetState
    extends State<UploadCalculationBottomSheet> {
  String? selectedSite;
  final sites = ['Basic Calculator', 'Advanced Calculator'];
  final TextEditingController titleController = TextEditingController();

  bool isUploaded = false;
  bool isUploading = false;
  double uploadProgress = 0.0;
  String fileName = 'File name.pdf';
  String fileSize = '250Kb';
  

  void _startUpload() {
    setState(() {
      isUploading = true;
      uploadProgress = 0.0;
    });
    // Simulate upload progress
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        uploadProgress = 75.0;
      });
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          isUploading = false;
          isUploaded = true;
        });
      });
    });
  }

  void _resetUpload() {
    setState(() {
      isUploaded = false;
      isUploading = false;
      uploadProgress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top drag handle
            Container(
              width: 60,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Upload Calculation Data',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF23262F),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Calculation Type Dropdown
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Calculation Type',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF23262F),
                ),
              ),
            ),
            LabeledDropdown<String>(
              label: '',
              hintText: 'Select Site',
              items: sites
                  .map((site) => DropdownMenuItem(
                        value: site,
                        child: Text(site),
                      ),)
                  .toList(),
              value: selectedSite,
              onChanged: (val) => setState(() => selectedSite = val),
            ),
            const SizedBox(height: 20),
            // Save as TextField
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Save as',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF23262F),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter title',
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
            const SizedBox(height: 20),
            // File Upload Box
            FileUploadBox(
              isUploaded: isUploaded,
              isUploading: isUploading,
              uploadProgress: uploadProgress,
              fileName: fileName,
              fileSize: fileSize,
              fileIconPath: 'assets/images/pdf.png',
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
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
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
                      onPressed: () {
                        // Handle upload
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
                      child: const Text(
                        'Upload',
                        style: TextStyle(
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
