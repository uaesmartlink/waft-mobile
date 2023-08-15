import 'package:get/get.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/modules/main_feature/manager_bookings/manager_bookings_controller.dart';

class ManagerBookingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ManagerBookingsController(
        activitiesRepository: Get.find<ActivitiesRepository>(),
      ),
    );
  }
}
