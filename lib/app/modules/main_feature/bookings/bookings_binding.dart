import 'package:get/get.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/modules/main_feature/bookings/bookings_controller.dart';

class BookingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      BookingsController(
        activitiesRepository: Get.find<ActivitiesRepository>(),
      ),
    );
  }
}
