import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_template/app/Pages/main/views/main_view.dart';
import 'package:flutter_template/app/Pages/plan/controllers/plan_controller.dart';
import 'package:flutter_template/app/core/config/app_color.dart';
import 'package:flutter_template/app/data/models/operational_planning_model.dart';
import 'package:flutter_template/app/routes/app_routes.dart';

import 'package:flutter_template/app/shared/widgets/app_button.dart';
import 'package:flutter_template/app/shared/widgets/app_title.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PlanTable extends StatefulWidget {
  PlanTable({required this.planData, super.key});
  RxList<OperationalPlanningModel> planData = <OperationalPlanningModel>[].obs;
  final planController = Get.find<PlanController>();

  @override
  State<PlanTable> createState() => _PlanTableState();
}

class _PlanTableState extends State<PlanTable> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    return widget.planData.isEmpty
        ? Column(
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
                'There are no plans for this site'.tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textBlack100,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(
                height: 16,
              ),
              AppButton(
                text: 'Generate Plan',
                onPressed: () => {
                  Get.off<void>(
                    () => MainView(
                      initialIndex: 3,
                    ),
                  ),
                },
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTitle(titleName: 'Calculation Histories'),
              const SizedBox(height: 16),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                    overscroll: false,
                  ),
                  child: ScrollbarTheme(
                    data: ScrollbarThemeData(
                      thumbColor: WidgetStateProperty.all(
                        AppColors.stroke100,
                      ),
                      trackColor: WidgetStateProperty.all(
                        AppColors.background60,
                      ),
                      trackVisibility: WidgetStateProperty.all(true),
                      thickness: WidgetStateProperty.all(6),
                      radius: const Radius.circular(32),
                      minThumbLength: 4,
                      thumbVisibility: WidgetStateProperty.all(true),
                      trackBorderColor: WidgetStateProperty.all(
                        Colors.transparent,
                      ), // Remove track border
                      crossAxisMargin:
                          0, // Remove any margin around the scrollbar
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
                              // Header
                              Container(
                                height: 54.h,
                                padding: EdgeInsets.only(left: 8.w),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    _buildHeaderCell(
                                      'Plan Name',
                                      context,
                                      width: 154,
                                    ),
                                    _buildHeaderCell(
                                      'Saved Date',
                                      context,
                                      width: 200,
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ...widget.planData.map(
                                        (row) => GestureDetector(
                                          onTap: () {
                                            Get.toNamed<void>(
                                              AppRoutes.OPERATIONAL_SUMMARY,
                                              arguments: {
                                                'data': row,
                                                'isFromTable': true
                                              },
                                            );
                                            // widget.planController
                                            //     .calculateFermentation();
                                            // widget.planController
                                            //     .calculateSoaking();
                                            // widget.planController
                                            //     .calculateDrying();
                                            // widget.planController
                                            //     .calculateBagging();
                                            // widget.planController
                                            //     .calculateWashedOutput();
                                            // widget.planController
                                            //     .calculateNaturalOutput();
                                            // widget.planController
                                            //     .onDataSubmit();
                                          },
                                          child: Container(
                                            height: 54.h,
                                            padding: EdgeInsets.only(left: 8.w),
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: AppColors.secondary,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                _buildRowCell(
                                                  row.savedTitle,
                                                  context,
                                                  width: 154,
                                                ),
                                                _buildRowCell(
                                                  DateFormat('MMM d, yyyy')
                                                      .format(row.createdAt),
                                                  context,
                                                  width: 200,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Data rows
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
