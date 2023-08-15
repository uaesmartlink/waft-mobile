import 'package:get/get.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/modules/main_feature/payment_history/payment_history_controller.dart';

class PaymentHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      PaymentHistoryController(
        activitiesRepository: Get.find<ActivitiesRepository>(),
      ),
    );
  }
}
