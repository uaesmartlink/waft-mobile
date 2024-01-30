import 'package:get/get.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/models/package_model.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/services/request_mixin.dart';

import '../../../core/services/getx_state_controller.dart';

class BookingResultController extends GetxStateController {
  final ActivitiesRepository activitiesRepository;
  late final Activity activity;
  late final Package package;
  late final DateTime date;
  late final String paymentResultUrl;
  bool paymentResult = false;
  BookingResultController({required this.activitiesRepository});
  @override
  void onInit() {
    activity = Get.arguments["activity"];
    date = Get.arguments["date"];
    package = Get.arguments["selectedPackage"];
    paymentResultUrl = Get.arguments["paymentResultUrl"];
    paymentCallback();
    super.onInit();
  }

  Future<void> paymentCallback() async {
    print("-------------------------");
    print("CallBack");
    print("-------------------------");
    requestMethod(
      ids: ["BookingResultView"],
      requestType: RequestType.getData,
      function: () async {
        Uri url = Uri.parse(paymentResultUrl);
        String bookingId = url.queryParameters['bookingId'] ?? "";
        String id = url.queryParameters['ref'] ?? "";

        paymentResult = await activitiesRepository.paymentCallback(
          id: id,
          bookingId: int.parse(bookingId),
        );
        return null;
      },
    );
  }
}
