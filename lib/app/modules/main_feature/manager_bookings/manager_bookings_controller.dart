import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/models/booking_model.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/services/data_list_mixin.dart';
import 'package:sport/app/core/services/request_mixin.dart';

import '../../../core/services/getx_state_controller.dart';

class ManagerBookingsController extends GetxStateController
    with GetSingleTickerProviderStateMixin, DataList<Booking> {
  late final TabController tabController;
  ManagerBookingsController({
    required this.activitiesRepository,
  });
  final ActivitiesRepository activitiesRepository;
  int tabBarIndex = 0;
  void changeSelectedTabBarIndex(int tabBarIndex) {
    this.tabBarIndex = tabBarIndex;
    update(["TabBar"]);
    if (tabBarIndex == 0) {
      filter = "incomplete";
      type = "time_slot";
    } else if (tabBarIndex == 1) {
      filter = "completed";
      type = "time_slot";
    } else if (tabBarIndex == 2) {
      filter = "cancelled";
      type = "time_slot";
    } else if (tabBarIndex == 3) {
      filter = null;
      type = "subscription";
    }
    getUserManagerBookings();
  }

  String? filter = "incomplete";
  String type = "time_slot";
  CancelToken getUserManagerBookingsCancelToken = CancelToken();
  Future<void> getUserManagerBookings(
      [RequestType requestType = RequestType.getData]) async {
    await handelDataList(
      ids: ["getUserManagerBookings"],
      requestType: requestType,
      function: () async {
        getUserManagerBookingsCancelToken.cancel("cancel by next request");
        getUserManagerBookingsCancelToken = CancelToken();
        return await activitiesRepository.getManagerBookings(
          page: page,
          cancelToken: getUserManagerBookingsCancelToken,
          type: type,
          status: filter,
          stadiumId: getManagerActivityForm.value["stadium_id"] as int?,
        );
      },
    );
  }

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: this);
    getManagerActivity();
    getUserManagerBookings();
    super.onInit();
  }

  Future<void> deleteBooking({
    required int bookingId,
  }) async {
    await requestMethod(
      ids: ["deleteBookingDialog"],
      requestType: RequestType.getData,
      function: () async {
        await activitiesRepository.cancelBooking(bookingId: bookingId);
        await getUserManagerBookings(RequestType.refresh);
        Get.back();
        return null;
      },
    );
  }

  FormGroup getManagerActivityForm = FormGroup({
    "stadium_id": FormControl<int>(),
  });
  List<Activity> managerActivity = [];
  Future<void> getManagerActivity(
      [RequestType requestType = RequestType.getData]) async {
    await requestMethod(
      ids: ["getManagerActivity"],
      requestType: requestType,
      function: () async {
        managerActivity = await activitiesRepository.getManagerActivity();
        return null;
      },
    );
  }
}
