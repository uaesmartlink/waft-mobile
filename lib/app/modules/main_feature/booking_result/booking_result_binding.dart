import 'package:get/get.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';

import 'booking_result_controller.dart';

class BookingResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      BookingResultController(
          activitiesRepository: Get.find<ActivitiesRepository>()),
    );
  }
}
