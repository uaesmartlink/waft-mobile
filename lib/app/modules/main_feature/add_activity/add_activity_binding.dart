import 'package:get/get.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';

import 'add_activity_controller.dart';

class AddActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      AddActivityController(
        activitiesRepository: Get.find<ActivitiesRepository>(),
        constantsRepository: Get.find<ConstantsRepository>(),
      ),
    );
  }
}
