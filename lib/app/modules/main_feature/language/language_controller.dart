import 'package:get/get.dart';
import 'package:sport/app/core/localization/translation.dart';
import 'package:sport/app/modules/main_feature/activities/activities_controller.dart';
import 'package:sport/app/modules/main_feature/bookings/bookings_controller.dart';
import 'package:sport/app/modules/main_feature/home/home_controller.dart';
import 'package:sport/app/modules/main_feature/manager_activities/manager_activities_controller.dart';
import 'package:sport/app/modules/main_feature/manager_bookings/manager_bookings_controller.dart';
import 'package:sport/app/modules/main_feature/manager_home/manager_home_controller.dart';

import '../../../core/services/getx_state_controller.dart';

class LanguageController extends GetxStateController {
  String selectedLanguage = Translation.languageCode;
  void changeSelectedLanguage(String languageCode) {
    selectedLanguage = languageCode;
    Translation.changeSelectedLanguage(languageCode);
    update(["changeSelectedLanguage"]);
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().refreshHomeData();
    }
    if (Get.isRegistered<ActivitiesController>()) {
      Get.find<ActivitiesController>().getActivityTypes();
    }
    if (Get.isRegistered<BookingsController>()) {
      Get.find<BookingsController>().getUserBookings();
    }
    if (Get.isRegistered<ManagerHomeController>()) {
      Get.find<ManagerHomeController>().refreshManagerHomeData();
    }
    if (Get.isRegistered<ManagerActivitiesController>()) {
      Get.find<ManagerActivitiesController>().getManagerActivity();
    }
    if (Get.isRegistered<ManagerBookingsController>()) {
      Get.find<ManagerBookingsController>().getUserManagerBookings();
      Get.find<ManagerBookingsController>().getManagerActivity();
    }
  }
}
