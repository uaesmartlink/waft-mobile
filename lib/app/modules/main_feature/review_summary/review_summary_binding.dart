import 'package:get/get.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/modules/main_feature/review_summary/review_summary_controller.dart';

class ReviewSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ReviewSummaryController(
        activitiesRepository: Get.find<ActivitiesRepository>(),
      ),
    );
  }
}
