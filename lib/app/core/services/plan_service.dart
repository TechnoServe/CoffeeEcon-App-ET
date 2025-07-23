import 'package:flutter_template/app/data/models/operational_planning_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service for managing operational plans using Hive storage.
class PlanService {
  /// Initializes the plan service and opens the Hive box.
  Future<PlanService> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(OperationalPlanningModelAdapter());

    await Hive.openBox<OperationalPlanningModel>('operational_plan');

    return this;
  }

  /// The Hive box for operational plans.
  Box<OperationalPlanningModel> get _planBox =>
      Hive.box<OperationalPlanningModel>('operational_plan');

  /// Adds a new operational plan.
  Future<bool> addPlan(OperationalPlanningModel plan) async {
    try {
      print({
        'plane addeddddddddddddddd savedddddddddddddddddddddddddddddddddddddd',
        plan.selectedSites,
      });

      await _planBox.put(plan.id, plan);
      print({
        'plane savedddddddddddddddddddddddddddddddddddddd',
        plan.selectedSites
      });

      return true;
    } catch (e) {
      print({'errrrrrrrrrrrrrrrrrrrrrrrrrrrrrr', e});
      return false;
    }
  }

  /// Returns all operational plans, optionally limited by [limit].
  List<OperationalPlanningModel> getAllPlans({int? limit}) {
    final plans = _planBox.values.toList();
    plans.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first
    if (limit != null) {
      return plans.take(limit).toList();
    }

    return plans;
  }

  /// Returns all plans for a specific site by [siteId].
  List<OperationalPlanningModel> getPlansBySite({
    required String siteId,
  }) {
    final plans = _planBox.values
        .where(
          (model) => model.selectedSites.any(
            (site) => site['siteId'] == siteId,
          ),
        )
        .toList();
    plans.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first
    print({'load plannnnnnnnnnnnnnnnnnnnnnnn', plans});
    return plans;
  }

  /// Updates an existing operational plan.
  Future<bool> updatePlan(OperationalPlanningModel plan) async {
    try {
      await _planBox.put(plan.id, plan);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deletes a plan by its [id].
  Future<void> deletePlan(String id) async {
    await _planBox.delete(id);
  }
}
