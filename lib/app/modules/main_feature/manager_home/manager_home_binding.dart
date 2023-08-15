import 'package:get/get.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';

import 'manager_home_controller.dart';

class ManagerHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ManagerHomeController(
        activitiesRepository: Get.find<ActivitiesRepository>()));
  }
}
