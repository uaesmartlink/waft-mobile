import 'package:get/get.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';

import 'book_appointment_controller.dart';

class BookAppointmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      BookAppointmentController(
          activitiesRepository: Get.find<ActivitiesRepository>()),
    );
  }
}
