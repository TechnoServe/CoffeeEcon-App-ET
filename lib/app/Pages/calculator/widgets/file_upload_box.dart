import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:get/get.dart';

class FileUploadBox extends StatelessWidget {
  const FileUploadBox({
    required this.isUploaded,
    required this.isUploading,
    required this.uploadProgress,
    required this.fileName,
    required this.fileSize,
    required this.onBrowse,
    required this.onDelete,
    super.key,
    this.fileIconPath,
  });
  final bool isUploaded;
  final bool isUploading;
  final double uploadProgress; // 0.0 - 1.0
  final String fileName;
  final String fileSize;
  final VoidCallback onBrowse;
  final VoidCallback onDelete;
  final String? fileIconPath;

  @override
  Widget build(BuildContext context) {
    if (isUploaded) {
      // Uploaded file UI
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: Row(
          children: [
            // File info section
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF00B3B0),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    if (fileIconPath != null)
                      Image.asset(
                        fileIconPath!,
                        width: 28,
                        height: 28,
                      )
                    else
                      const Icon(
                        Icons.insert_drive_file,
                        size: 28,
                        color: Color(0xFFB0B7C3),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        fileName,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Text(
                      fileSize,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.background60,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/delete.svg',
                  width: 18,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.grey80,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: onDelete,
                tooltip: 'Remove file',
              ),
            ),
          ],
        ),
      );
    } else if (isUploading) {
      // Uploading progress UI
      return Stack(
        children: [
          // Progress background

          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.background60,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = MediaQuery.of(context).size.width /
                    2.2 *
                    (uploadProgress.clamp(0.0, 1.0));
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: width,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F7FA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          ),
          // Foreground content
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Uploading...',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Text(
                    '${uploadProgress.toInt()}%',
                    style: const TextStyle(
                      color: Color(0xFF11696D),
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // Dashed Add File/Browse UI
      return CustomPaint(
        painter: _DashedBorderPainter(
          color: const Color(0xFFD1D5DB),
          radius: 10,
          dashWidth: 6,
          dashSpace: 4,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add File'.tr,
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onBrowse,
                child: Text(
                  'Browse'.tr,
                  style: TextStyle(
                    color: Color(0xFF11696D),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    this.radius = 10,
    this.dashWidth = 6,
    this.dashSpace = 4,
  });
  final Color color;
  final double radius;
  final double dashWidth;
  final double dashSpace;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    _drawDashedRRect(canvas, rrect, paint, dashWidth, dashSpace);
  }

  void _drawDashedRRect(
    Canvas canvas,
    RRect rrect,
    Paint paint,
    double dashWidth,
    double dashSpace,
  ) {
    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics().toList();

    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final len = (distance + dashWidth < metric.length)
            ? dashWidth
            : metric.length - distance;
        canvas.drawPath(
          metric.extractPath(distance, distance + len),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
