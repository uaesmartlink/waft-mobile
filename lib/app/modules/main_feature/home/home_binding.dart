import 'package:get/get.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';

import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController(
      constantsRepository: Get.find<ConstantsRepository>(),
      activitiesRepository: Get.find<ActivitiesRepository>(),
    ));
  }
}
