import 'package:get/get.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';

import 'activities_controller.dart';

class ActivitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ActivitiesController(
          constantsRepository: Get.find<ConstantsRepository>()),
    );
  }
}
