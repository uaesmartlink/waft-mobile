import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/services/notifications/firebase_cloud_messaging.dart';
import 'package:sport/app/core/widgets/go_login.dart';
import 'package:sport/app/modules/main_feature/activities/activities_binding.dart';
import 'package:sport/app/modules/main_feature/activities/activities_controller.dart';
import 'package:sport/app/modules/main_feature/bookings/bookings_binding.dart';
import 'package:sport/app/modules/main_feature/bookings/bookings_controller.dart';
import 'package:sport/app/modules/main_feature/manager_activities/manager_activities_binding.dart';
import 'package:sport/app/modules/main_feature/manager_bookings/manager_bookings_binding.dart';
import 'package:sport/app/modules/main_feature/manager_bookings/manager_bookings_controller.dart';
import 'package:sport/app/modules/main_feature/profile/profile_binding.dart';
import 'package:sport/app/modules/main_feature/profile/profile_controller.dart';

import '../../../core/services/getx_state_controller.dart';

class HomeStructuringController extends GetxStateController {
  int pageIndex = 0;
  PageController pageController = PageController();
  void changePageIndex(int pageIndex) {
    if (!DataHelper.logedIn && pageIndex == 2) {
      loginBottomSheet(description: LanguageKey.loginToViewBookings.tr);
      return;
    }
    if (pageIndex == 1 && !Get.isRegistered<ActivitiesController>()) {
      ActivitiesBinding().dependencies();
    } else if (pageIndex == 2 && !Get.isRegistered<BookingsController>()) {
      BookingsBinding().dependencies();
    } else if (pageIndex == 3 && !Get.isRegistered<ProfileController>()) {
      ProfileBinding().dependencies();
    }
    this.pageIndex = pageIndex;
    pageController.jumpToPage(
      pageIndex,
    );
    update(["BottomNavigationBar"]);
  }

  void changeManagerPageIndex(int pageIndex) {
    if (pageIndex == 1 && !Get.isRegistered<ActivitiesController>()) {
      ManagerActivitiesBinding().dependencies();
    } else if (pageIndex == 2 &&
        !Get.isRegistered<ManagerBookingsController>()) {
      ManagerBookingsBinding().dependencies();
    } else if (pageIndex == 2 &&
        Get.find<ManagerBookingsController>().managerActivity.isEmpty) {
      Get.find<ManagerBookingsController>().getManagerActivity();
    } else if (pageIndex == 3 && !Get.isRegistered<ProfileController>()) {
      ProfileBinding().dependencies();
    }
    this.pageIndex = pageIndex;
    pageController.jumpToPage(
      pageIndex,
    );
    update(["BottomNavigationBar"]);
  }

  @override
  void onInit() {
    NotificationService.instance.requestPermission();
    super.onInit();
  }
}
