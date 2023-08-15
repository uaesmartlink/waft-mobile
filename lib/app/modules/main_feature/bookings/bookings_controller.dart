import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/constants/request_routes.dart';
import 'package:sport/app/core/models/booking_model.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/services/data_list_mixin.dart';
import 'package:sport/app/core/services/request_mixin.dart';

import '../../../core/services/getx_state_controller.dart';

class BookingsController extends GetxStateController
    with GetSingleTickerProviderStateMixin, DataList<Booking> {
  late final TabController tabController;
  BookingsController({
    required this.activitiesRepository,
  });
  final ActivitiesRepository activitiesRepository;
  int tabBarIndex = 0;
  void changeSelectedTabBarIndex(int tabBarIndex) {
    this.tabBarIndex = tabBarIndex;
    update(["TabBar"]);
    if (tabBarIndex == 0) {
      filter = RequestRoutes.userUpcomingBookings;
      type = "time_slot";
    } else if (tabBarIndex == 1) {
      filter = RequestRoutes.userCompletedBookings;
      type = "time_slot";
    } else if (tabBarIndex == 2) {
      filter = RequestRoutes.userCancelledBookings;
      type = "time_slot";
    } else if (tabBarIndex == 3) {
      filter = RequestRoutes.userBookings;
      type = "subscription";
    }
    getUserBookings();
  }

  String filter = RequestRoutes.userUpcomingBookings;
  String type = "time_slot";
  CancelToken getUserBookingsCancelToken = CancelToken();
  Future<void> getUserBookings(
      [RequestType requestType = RequestType.getData]) async {
    await handelDataList(
      ids: ["getUserBookings"],
      requestType: requestType,
      function: () async {
        getUserBookingsCancelToken.cancel("cancel by next request");
        getUserBookingsCancelToken = CancelToken();
        return await activitiesRepository.getUserBookings(
          page: page,
          filter: filter,
          cancelToken: getUserBookingsCancelToken,
          type: type,
        );
      },
    );
  }

  Future<void> deleteBooking({
    required int bookingId,
  }) async {
    await requestMethod(
      ids: ["deleteBookingDialog"],
      requestType: RequestType.getData,
      function: () async {
        await activitiesRepository.cancelBooking(bookingId: bookingId);
        await getUserBookings(RequestType.refresh);
        Get.back();
        return null;
      },
    );
  }

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: this);
    getUserBookings();
    super.onInit();
  }
}
