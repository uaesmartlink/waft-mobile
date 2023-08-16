import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/localization/translation.dart';
import 'package:sport/app/core/models/package_model.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';
import 'package:sport/app/core/widgets/go_login.dart';
import 'package:sport/app/core/widgets/no_internet.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/shared/constant/home_routes.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../app_constants/app_dimensions.dart';
import 'book_appointment_controller.dart';

class BookAppointmentView extends GetView<BookAppointmentController> {
  const BookAppointmentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: AppBar(
          toolbarHeight: 100,
          title: Text(LanguageKey.bookAppointment.tr),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(AppDimensions.generalPadding, 0, AppDimensions.generalPadding, 2),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (!DataHelper.logedIn) {
                loginBottomSheet(
                    description: LanguageKey.loginToBookAppointment.tr);
                return;
              }
              if (controller.selectedPackage == null) {
                AppMessenger.message(LanguageKey.selectBookingTypeFirst.tr);
              } else if (controller.selectedPackage!.packageType ==
                      PackageType.timeSlot &&
                  controller.selectedHour == null) {
                AppMessenger.message(LanguageKey.specifyHour.tr);
              } else {
                String dateString = DateFormat('yyyy-MM-dd', "en")
                    .format(controller.selectedDate);
                String combinedString =
                    "$dateString ${controller.selectedHour?.time}";
                DateTime parsedDateTime = controller.selectedHour == null
                    ? controller.selectedDate
                    : DateFormat('yyyy-MM-dd HH:mm', "en")
                        .parse(combinedString);
                Get.toNamed(
                  HomeRoutes.reviewSummaryRoute,
                  arguments: {
                    "activity": controller.activity,
                    "date": parsedDateTime,
                    "selectedPackage": controller.selectedPackage,
                  },
                );
              }
            },
            child: Text(LanguageKey.continueKye.tr),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, AppDimensions.generalPadding, 0, 80),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.generalPadding),
            child: Text(
              LanguageKey.selectBookingType.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GetBuilder<BookAppointmentController>(
              id: "selectedPackage",
              builder: (context) {
                return SizedBox(
                  height: 170,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppDimensions.generalPadding),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final Package package =
                          controller.activity.packages[index];
                      return InkWell(
                        onTap: () {
                          controller.changeSelectedPackage(package);
                        },
                        child: Container(
                          width: 220,
                          padding: const EdgeInsets.all(AppDimensions.generalPadding),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  controller.selectedPackage?.id == package.id
                                      ? AppColors.primary
                                      : AppColors.fontGray,
                              width:
                                  controller.selectedPackage?.id == package.id
                                      ? 2
                                      : 1,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                package.name,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                package.packageType == PackageType.timeSlot
                                    ? LanguageKey.oneTimeReservation.tr
                                    : LanguageKey.subscription.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.fontGray,
                                ),
                              ),
                              Text(
                                "${package.price} ${LanguageKey.dirhams.tr}",
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: AppDimensions.generalPadding);
                    },
                    itemCount: controller.activity.packages.length,
                  ),
                );
              }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.generalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LanguageKey.selectDate.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.generalPadding),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.splash,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: GetBuilder<BookAppointmentController>(
                    id: "TableCalendar",
                    builder: (context) {
                      return TableCalendar(
                        firstDay: DateTime.now(),
                        locale: Translation.currentLanguage.languageCode,
                        availableGestures: AvailableGestures.horizontalSwipe,
                        lastDay: DateTime.now().add(const Duration(days: 90)),
                        focusedDay: controller.selectedDate,
                        currentDay: controller.selectedDate,
                        rangeSelectionMode: RangeSelectionMode.disabled,
                        daysOfWeekHeight: 20,
                        headerStyle:
                            const HeaderStyle(formatButtonVisible: false),
                        calendarStyle: const CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          controller.changeSelectedDay(selectedDay);
                        },
                      );
                    },
                  ),
                ),
                GetBuilder<BookAppointmentController>(
                  id: "selectHours",
                  builder: (controller) {
                    if (controller.selectedPackage?.packageType ==
                        PackageType.timeSlot) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppDimensions.generalPadding),
                          Text(
                            LanguageKey.selectHours.tr,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.generalPadding),
                          StateBuilder<BookAppointmentController>(
                            id: "getAvailableTimes",
                            builder: (widgetState, controller) {
                              return Wrap(
                                spacing: 10,
                                runSpacing: 5,
                                children: controller.availableTimes
                                    .map((availableTime) => GestureDetector(
                                          onTap: () {
                                            if (availableTime.booked) {
                                              AppMessenger.message(
                                                  LanguageKey.alreadyBooked.tr);
                                            } else {
                                              controller.changeSelectedHour(
                                                  availableTime);
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: availableTime.booked
                                                  ? null
                                                  : Border.all(
                                                      color: AppColors.primary),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: availableTime ==
                                                      controller.selectedHour
                                                  ? AppColors.primary
                                                  : availableTime.booked
                                                      ? AppColors.codeInput
                                                      : AppColors.background,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: AppDimensions.generalPadding,
                                            ),
                                            child: Text(
                                              availableTime.dateFormated,
                                              style: TextStyle(
                                                color: availableTime ==
                                                        controller.selectedHour
                                                    ? AppColors.background
                                                    : availableTime.booked
                                                        ? AppColors.fontGray
                                                        : AppColors.font,
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              );
                            },
                            errorView: SizedBox(
                              height: 150,
                              child: NoInternetConnection(
                                  onRetryFunction:
                                      controller.getAvailableTimes),
                            ),
                            noResultView: SizedBox(
                              height: 150,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.search_off_rounded),
                                    const SizedBox(width: 10),
                                    Text(LanguageKey.noAvailableHours.tr),
                                  ],
                                ),
                              ),
                            ),
                            loadingView: Wrap(
                              spacing: 10,
                              runSpacing: 5,
                              children: List.generate(
                                10,
                                (index) {
                                  return index;
                                },
                              )
                                  .map((e) => Shimmer.fromColors(
                                        baseColor: AppColors.codeInput,
                                        highlightColor: AppColors.background,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: AppDimensions.generalPadding,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: AppColors.codeInput,
                                          ),
                                          width: e % 3 * 50 + 100,
                                          child: const Text(""),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
