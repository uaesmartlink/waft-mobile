import 'package:get/get.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/modules/main_feature/activity_details/activity_details_controller.dart';

class ActivityDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ActivityDetailsController(
        activitiesRepository: Get.find<ActivitiesRepository>(),
        constantsRepository: Get.find<ConstantsRepository>(),
      ),
    );
  }
}
