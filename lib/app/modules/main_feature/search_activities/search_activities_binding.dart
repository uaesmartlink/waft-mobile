import 'package:get/get.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/modules/main_feature/search_activities/search_activities_controller.dart';

class SearchActivitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      SearchActivitiesController(
        activitiesRepository: Get.find<ActivitiesRepository>(),
        constantsRepository: Get.find<ConstantsRepository>(),
      ),
    );
  }
}
