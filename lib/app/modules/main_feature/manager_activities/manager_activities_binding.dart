import 'package:get/get.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';

import 'manager_activities_controller.dart';

class ManagerActivitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ManagerActivitiesController(
        activitiesRepository: Get.find<ActivitiesRepository>(),
      ),
    );
  }
}
