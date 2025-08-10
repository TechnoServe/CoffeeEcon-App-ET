import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/app/Pages/calculator/controllers/calculator_controller.dart';
import 'package:flutter_template/app/Pages/main/views/main_view.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/data/models/save_breakdown_model.dart';
import 'package:flutter_template/app/routes/app_routes.dart';
import 'package:flutter_template/app/shared/widgets/app_button.dart';
import 'package:flutter_template/app/shared/widgets/app_title.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalculationHistoryTable extends StatefulWidget {
  CalculationHistoryTable({required this.siteCalculationHistory, super.key});
  RxList<SavedBreakdownModel> siteCalculationHistory =
      <SavedBreakdownModel>[].obs;

  @override
  State<CalculationHistoryTable> createState() =>
      _CalculationHistoryTableState();
}

class _CalculationHistoryTableState extends State<CalculationHistoryTable> {
  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  // }

  // @override
  // void dispose() {
  //   // Restore portrait-only mode when leaving this screen
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    return widget.siteCalculationHistory.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nothing Here!'.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textBlack100,
                      ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'There are no calculations histories in this site'.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textBlack100,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(
                  height: 16,
                ),
                AppButton(
                  text: 'Calculate',
                  onPressed: () => {
                    Get.off<void>(
                      () => MainView(
                        initialIndex: 1,
                      ),
                    ),
                  },
                ),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTitle(titleName: 'Calculation Histories'),
              const SizedBox(height: 16),
              ScrollConfiguration(
  behavior: ScrollConfiguration.of(context).copyWith(
    scrollbars: false,
    overscroll: false,
  ),
  child: ScrollbarTheme(
    data: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.stroke100),
      trackColor: WidgetStateProperty.all(AppColors.background60),
      trackVisibility: WidgetStateProperty.all(true),
      thickness: WidgetStateProperty.all(6),
      radius: const Radius.circular(32),
      minThumbLength: 4,
      thumbVisibility: WidgetStateProperty.all(true),
      trackBorderColor: WidgetStateProperty.all(Colors.transparent),
      crossAxisMargin: 0,
    ),
    child: Scrollbar(
      thumbVisibility: true,
      interactive: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Container(
                height: 54.h,
                padding: EdgeInsets.only(left: 8.w),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    _buildHeaderCell('Calculation Type', context, width: 154),
                    _buildHeaderCell('Saved Date', context, width: 200),
                    _buildHeaderCell('Calculation Name', context, width: 200),
                    _buildHeaderCell('Break Even Price', context, width: 200),
                    _buildHeaderCell('Status', context, width: 154),
                  ],
                ),
              ),

              // Data rows — no Expanded here
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...widget.siteCalculationHistory.map(
                      (row) => GestureDetector(
                        onTap: () {
                          Get.toNamed<void>(
                            AppRoutes.RESULTSOVERVIEWVIEW,
                            arguments: {
                              'type': ResultsOverviewTypeExtension.fromString(
                                row.type.name,
                              ),
                              'basicCalcData': row.basicCalculation,
                              'advancedCalcData': row.advancedCalculation,
                              'breakEvenPrice': row.breakEvenPrice,
                              'isBestPractice': row.isBestPractice,
                            },
                          );
                        },
                        child: Container(
                          height: 54.h,
                          padding: EdgeInsets.only(left: 8.w),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppColors.secondary),
                            ),
                          ),
                          child: Row(
                            children: [
                              _buildRowCell(row.type.name, context, width: 154),
                              _buildRowCell(
                                DateFormat('MMM d, yyyy')
                                    .format(row.createdAt),
                                context,
                                width: 200,
                              ),
                              _buildRowCell(row.title, context, width: 200),
                              _buildRowCell(
                                row.breakEvenPrice?.toStringAsFixed(2) ?? '0',
                                context,
                                width: 200,
                              ),
                              SizedBox(
                                width: 154.w,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    row.isBestPractice
                                        ? '✅ Best Practice'
                                        : '⚠️ Below Market',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: row.isBestPractice
                                              ? AppColors.success
                                              : AppColors.success,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
)

              // Expanded(
              //   child: ScrollConfiguration(
              //     behavior: ScrollConfiguration.of(context).copyWith(
              //       scrollbars: false,
              //       overscroll: false,
              //     ),
              //     child: ScrollbarTheme(
              //       data: ScrollbarThemeData(
              //         thumbColor: WidgetStateProperty.all(
              //           AppColors.stroke100,
              //         ),
              //         trackColor: WidgetStateProperty.all(
              //           AppColors.background60,
              //         ),
              //         trackVisibility: WidgetStateProperty.all(true),
              //         thickness: WidgetStateProperty.all(6),
              //         radius: const Radius.circular(32),
              //         minThumbLength: 4,
              //         thumbVisibility: WidgetStateProperty.all(true),
              //         trackBorderColor: WidgetStateProperty.all(
              //           Colors.transparent,
              //         ), // Remove track border
              //         crossAxisMargin:
              //             0, // Remove any margin around the scrollbar
              //       ),
              //       child: Scrollbar(
              //         thumbVisibility: true,
              //         interactive: true,
              //         child: SingleChildScrollView(
              //           scrollDirection: Axis.horizontal,
              //           child: Padding(
              //             padding: const EdgeInsets.only(bottom: 32),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 // Header
              //                 Container(
              //                   height: 54.h,
              //                   padding: EdgeInsets.only(left: 8.w),
              //                   decoration: BoxDecoration(
              //                     color: AppColors.secondary,
              //                     borderRadius: BorderRadius.circular(8.r),
              //                   ),
              //                   child: Row(
              //                     children: [
              //                       _buildHeaderCell(
              //                         'Calculation Type',
              //                         context,
              //                         width: 154,
              //                       ),
              //                       _buildHeaderCell(
              //                         'Saved Date',
              //                         context,
              //                         width: 200,
              //                       ),
              //                       _buildHeaderCell(
              //                         'Calculation Name',
              //                         context,
              //                         width: 200,
              //                       ),
              //                       _buildHeaderCell(
              //                         'Break Even Price',
              //                         context,
              //                         width: 200,
              //                       ),
              //                       _buildHeaderCell(
              //                         'Status',
              //                         context,
              //                         width: 154,
              //                       ),
              //                     ],
              //                   ),
              //                 ),

              //                 Expanded(
              //                   child: SingleChildScrollView(
              //                     child: Column(
              //                       mainAxisSize: MainAxisSize.min,
              //                       children: [
              //                         ...widget.siteCalculationHistory.map(
              //                           (row) => GestureDetector(
              //                             onTap: () {
              //                               Get.toNamed<void>(
              //                                 AppRoutes.RESULTSOVERVIEWVIEW,
              //                                 arguments: {
              //                                   'type':
              //                                       ResultsOverviewTypeExtension
              //                                           .fromString(
              //                                     row.type.name,
              //                                   ),
              //                                   'basicCalcData':
              //                                       row.basicCalculation,
              //                                   'advancedCalcData':
              //                                       row.advancedCalculation,
              //                                   'breakEvenPrice':
              //                                       row.breakEvenPrice,
              //                                   'isBestPractice':
              //                                       row.isBestPractice,
              //                                 },
              //                               );
              //                             },
              //                             child: Container(
              //                               height: 54.h,
              //                               padding: EdgeInsets.only(left: 8.w),
              //                               decoration: const BoxDecoration(
              //                                 border: Border(
              //                                   bottom: BorderSide(
              //                                     color: AppColors.secondary,
              //                                   ),
              //                                 ),
              //                               ),
              //                               child: Row(
              //                                 children: [
              //                                   _buildRowCell(
              //                                     row.type.name,
              //                                     context,
              //                                     width: 154,
              //                                   ),
              //                                   _buildRowCell(
              //                                     DateFormat('MMM d, yyyy')
              //                                         .format(row.createdAt),
              //                                     context,
              //                                     width: 200,
              //                                   ),
              //                                   _buildRowCell(
              //                                     row.title,
              //                                     context,
              //                                     width: 200,
              //                                   ),
              //                                   _buildRowCell(
              //                                     row.breakEvenPrice
              //                                             ?.toStringAsFixed(
              //                                           2,
              //                                         ) ??
              //                                         '0',
              //                                     context,
              //                                     width: 200,
              //                                   ),
              //                                   SizedBox(
              //                                     width: 154.w,
              //                                     child: Align(
              //                                       alignment:
              //                                           Alignment.centerLeft,
              //                                       child: Text(
              //                                         row.isBestPractice
              //                                             ? '✅ Best Practice'
              //                                             : '⚠️ Below Market',
              //                                         style: Theme.of(context)
              //                                             .textTheme
              //                                             .labelSmall
              //                                             ?.copyWith(
              //                                               color:
              //                                                   row.isBestPractice
              //                                                       ? AppColors
              //                                                           .success
              //                                                       : AppColors
              //                                                           .success,
              //                                             ),
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //                 // Data rows
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
           
            ],
          );
  }

  Widget _buildHeaderCell(
    String text,
    BuildContext context, {
    required double width,
  }) =>
      SizedBox(
        width: width.w,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text.tr,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: AppColors.textBlack100),
          ),
        ),
      );

  Widget _buildRowCell(
    String text,
    BuildContext context, {
    required double width,
  }) =>
      SizedBox(
        width: width.w,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text.tr,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      );

}
