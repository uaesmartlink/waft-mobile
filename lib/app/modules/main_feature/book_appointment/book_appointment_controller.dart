import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/models/available_time_mode.dart';
import 'package:sport/app/core/models/package_model.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/services/request_mixin.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';

import '../../../core/services/getx_state_controller.dart';

class BookAppointmentController extends GetxStateController {
  BookAppointmentController({required this.activitiesRepository});
  final ActivitiesRepository activitiesRepository;
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  Package? selectedPackage;
  AvailableTime? selectedHour;
  late final Activity activity;
  List<AvailableTime> availableTimes = [];
  @override
  void onInit() {
    activity = Get.arguments["activity"];
    super.onInit();
  }

  void changeSelectedPackage(Package selectedPackage) {
    this.selectedPackage = selectedPackage;
    selectedHour = null;
    availableTimes = [];
    if (selectedPackage.packageType == PackageType.timeSlot) {
      getAvailableTimes();
    }
    update(["selectHours", "selectedPackage"]);
  }

  void changeSelectedDay(DateTime selectedDate) {
    if (selectedPackage != null) {
      this.selectedDate = selectedDate;
      update(["TableCalendar"]);
      if (selectedPackage!.packageType == PackageType.timeSlot) {
        getAvailableTimes();
      }
    } else {
      AppMessenger.message(LanguageKey.selectBookingTypeFirst.tr);
    }
  }

  void changeSelectedHour(AvailableTime selectedHour) {
    this.selectedHour = selectedHour;
    update(["getAvailableTimes"]);
  }

  CancelToken getAvailableTimesCancelToken = CancelToken();
  Future<void> getAvailableTimes() async {
    await requestMethod(
      ids: ["getAvailableTimes"],
      requestType: RequestType.getData,
      function: () async {
        getAvailableTimesCancelToken.cancel("cancel by next request");
        getAvailableTimesCancelToken = CancelToken();
        availableTimes = await activitiesRepository.getAvailableTimes(
          date: selectedDate,
          stadiumId: activity.id,
          cancelToken: getAvailableTimesCancelToken,
          packageId: selectedPackage!.id,
        );
        selectedHour = null;
        return availableTimes;
      },
    );
  }
}
