import 'package:get/get.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/modules/main_feature/notifications/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      NotificationsController(
        activitiesRepository: Get.find<ActivitiesRepository>(),
      ),
    );
  }
}
