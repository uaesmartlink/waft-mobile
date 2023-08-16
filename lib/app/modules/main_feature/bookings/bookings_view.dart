import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/localization/translation.dart';
import 'package:sport/app/core/models/booking_model.dart';
import 'package:sport/app/core/services/request_mixin.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/elevated_button.dart';
import 'package:sport/app/core/widgets/pagination.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/bookings/bookings_controller.dart';
import 'package:sport/app/modules/main_feature/shared/constant/home_routes.dart';

import '../../../../app_constants/app_assets.dart';
import '../../../../app_constants/app_dimensions.dart';

class BookingsView extends GetView<BookingsController> {
  const BookingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: AppBar(
          toolbarHeight: 100,
          leading: Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset(
              AppAssets.logo,
            ),
          ),
          title: Text(
            LanguageKey.bookings.tr,
          ),
        ),
      ),
      body: ScreenSizer(
        builder: (CustomSize customSize) {
          return Column(
            children: [
              GetBuilder<BookingsController>(
                  id: "TabBar",
                  builder: (context) {
                    return SizedBox(
                      height: 40,
                      child: TabBar(
                        indicatorColor: AppColors.background,
                        automaticIndicatorColorAdjustment: false,
                        controller: controller.tabController,
                        isScrollable: true,
                        onTap: controller.changeSelectedTabBarIndex,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                        tabs: [
                          tabBarItem(
                            selected: controller.tabBarIndex == 0,
                            title: LanguageKey.upcoming.tr,
                          ),
                          tabBarItem(
                            selected: controller.tabBarIndex == 1,
                            title: LanguageKey.completed.tr,
                          ),
                          tabBarItem(
                            selected: controller.tabBarIndex == 2,
                            title: LanguageKey.canceled.tr,
                          ),
                          tabBarItem(
                            selected: controller.tabBarIndex == 3,
                            title: LanguageKey.subscriptions.tr,
                          ),
                        ],
                      ),
                    );
                  }),
              SizedBox(
                height: customSize.screenHeight - 40,
                child: StateBuilder<BookingsController>(
                  id: "getUserBookings",
                  onRetryFunction: controller.getUserBookings,
                  builder: (widgetState, controller) {
                    return PaginationBuilder<BookingsController>(
                      id: "getUserBookings",
                      onRefresh: () async {
                        await controller.getUserBookings(RequestType.refresh);
                      },
                      onRetryFunction: controller.getUserBookings,
                      onLoadingMore: () async {
                        await controller
                            .getUserBookings(RequestType.loadingMore);
                      },
                      builder: (scrollController) {
                        return ListView.separated(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(AppDimensions.generalPadding, AppDimensions.generalPadding, AppDimensions.generalPadding, 80),
                          itemBuilder: (context, index) {
                            final Booking booking = controller.dataList[index];
                            return Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                    offset: const Offset(1, 3),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ScreenSizer(
                                constWidth: 105,
                                builder: (CustomSize customSize) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${DateFormat.yMMMMd(Translation.languageCode).format(booking.startTime)} - ${DateFormat.jm(Translation.languageCode).format(booking.startTime)}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: AppDimensions.generalPadding, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: controller.tabBarIndex == 0
                                                  ? AppColors.primary
                                                  : controller.tabBarIndex == 1
                                                      ? AppColors.green
                                                      : controller.tabBarIndex ==
                                                              2
                                                          ? AppColors.red
                                                          : AppColors.green,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              controller.tabBarIndex == 0
                                                  ? LanguageKey.upcoming.tr
                                                  : controller.tabBarIndex == 1
                                                      ? LanguageKey.completed.tr
                                                      : controller.tabBarIndex ==
                                                              2
                                                          ? LanguageKey
                                                              .canceled.tr
                                                          : LanguageKey
                                                              .subscription.tr,
                                              style: const TextStyle(
                                                color: AppColors.background,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const Divider(height: 40),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: CachedNetworkImage(
                                                width: double.infinity,
                                                height: double.infinity,
                                                imageUrl: booking.stadium.image,
                                                placeholder: (_, __) =>
                                                    Shimmer.fromColors(
                                                  baseColor:
                                                      AppColors.background,
                                                  highlightColor: AppColors
                                                      .backgroundTextFilled,
                                                  child: const SizedBox(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                ),
                                                errorWidget: (_, __, ___) {
                                                  return const Placeholder();
                                                },
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: customSize.screenWidth,
                                            height: 80,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    booking.stadium.name,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    booking.stadium.address,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: AppColors.fontGray,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  if (booking.stadium.rating !=
                                                      null)
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          booking.stadium
                                                                      .rating! <
                                                                  2
                                                              ? Icons
                                                                  .star_border_rounded
                                                              : booking.stadium
                                                                          .rating ==
                                                                      5
                                                                  ? Icons
                                                                      .star_rounded
                                                                  : Icons
                                                                      .star_half_rounded,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Flexible(
                                                          child: Text(
                                                            booking
                                                                .stadium.rating!
                                                                .toStringAsFixed(
                                                                    1),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  else
                                                    const SizedBox(
                                                      height: 10,
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (controller.tabBarIndex != 2) ...[
                                        const Divider(height: 40),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: 50,
                                                width: double.infinity,
                                                child: OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: const BorderSide(
                                                      color: AppColors.primary,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        15,
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Get.toNamed(
                                                      HomeRoutes
                                                          .reviewSummaryRoute,
                                                      arguments: {
                                                        "activity":
                                                            booking.stadium,
                                                        "date":
                                                            booking.startTime,
                                                        "fromBookings": true,
                                                        "selectedPackage":
                                                            booking.package,
                                                      },
                                                    );
                                                  },
                                                  child: Text(LanguageKey
                                                      .viewSummary.tr),
                                                ),
                                              ),
                                            ),
                                            if (controller.tabBarIndex == 0 &&
                                                booking.startTime.isAfter(
                                                    DateTime.now().add(
                                                        const Duration(
                                                            minutes: 30)))) ...[
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    padding: EdgeInsets.zero,
                                                    side: const BorderSide(
                                                      color: AppColors.red,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        15,
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    deleteBookingDialog(
                                                        context: context,
                                                        booking: booking);
                                                  },
                                                  child: const Icon(
                                                    Icons.cancel,
                                                    color: AppColors.red,
                                                  ),
                                                ),
                                              )
                                            ]
                                          ],
                                        ),
                                      ]
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: AppDimensions.generalPadding);
                          },
                          itemCount: controller.dataList.length,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget tabBarItem({
    required bool selected,
    required String title,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: selected ? AppColors.primary : null,
        border: Border.all(color: AppColors.primary),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Center(
          child: Text(
        title,
        style: TextStyle(
          color: selected ? AppColors.background : AppColors.primary,
        ),
      )),
    );
  }

  void deleteBookingDialog({
    required BuildContext context,
    required Booking booking,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: AppColors.background,
          child: Container(
            padding: const EdgeInsets.all(30),
            width: MediaQuery.of(context).size.width - 100,
            child: SingleChildScrollView(
              child: StateBuilder<BookingsController>(
                  id: "deleteBookingDialog",
                  disableState: true,
                  initialWidgetState: WidgetState.loaded,
                  builder: (widgetState, controller) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          LanguageKey.cancelBooking.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          LanguageKey.cancelBookingText.tr,
                          style: const TextStyle(
                            color: AppColors.fontGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.generalPadding),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedStateButton(
                            widgetState: widgetState,
                            onPressed: () {
                              controller.deleteBooking(bookingId: booking.id);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: AppColors.red,
                            ),
                            child: Text(
                              LanguageKey.cancel.tr,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.generalPadding),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Get.back(),
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: AppColors.splash,
                            ),
                            child: Text(
                              LanguageKey.back.tr,
                              style: const TextStyle(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        );
      },
    );
  }
}
