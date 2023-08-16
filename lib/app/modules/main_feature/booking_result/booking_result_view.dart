import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/localization/translation.dart';
import 'package:sport/app/core/models/package_model.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/booking_result/booking_result_controller.dart';
import 'package:sport/app/modules/main_feature/home_module.dart';

import '../../../../app_constants/app_assets.dart';
import '../../../../app_constants/app_dimensions.dart';

class BookingResultView extends GetView<BookingResultController> {
  const BookingResultView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: AppBar(
          toolbarHeight: 100,
          title: Text(LanguageKey.bookingResult.tr),
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
              Get.offAllNamed(HomeModule.homeInitialRoute);
            },
            child: Text(LanguageKey.home.tr),
          ),
        ),
      ),
      body: StateBuilder<BookingResultController>(
          id: "BookingResultView",
          onRetryFunction: controller.paymentCallback,
          builder: (widgetState, controller) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(AppDimensions.generalPadding, AppDimensions.generalPadding, AppDimensions.generalPadding, 80),
              children: [
                if (controller.paymentResult)
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2,
                        child: Image.asset(AppAssets.done),
                      ),
                      const SizedBox(height: AppDimensions.generalPadding),
                      Text(
                        LanguageKey.paymentSuccessful.tr,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        LanguageKey.bookingSuccessfullyDone.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      const Icon(
                        Icons.close,
                        color: AppColors.red,
                        size: 150,
                      ),
                      Text(
                        LanguageKey.paymentFailed.tr,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.red,
                        ),
                      ),
                      Text(
                        LanguageKey.reservationFailed.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: AppDimensions.generalPadding),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.generalPadding),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(1, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        controller.activity.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.generalPadding),
                      item(
                        firstString: LanguageKey.address.tr,
                        secondString: controller.activity.address,
                      ),
                      const SizedBox(height: AppDimensions.generalPadding),
                      item(
                        firstString: LanguageKey.bookingDate.tr,
                        secondString:
                            DateFormat.yMMMMd(Translation.languageCode)
                                .format(controller.date),
                      ),
                      if (controller.package.packageType ==
                          PackageType.timeSlot) ...[
                        const SizedBox(height: AppDimensions.generalPadding),
                        item(
                          firstString: LanguageKey.bookingHour.tr,
                          secondString: DateFormat.jm(Translation.languageCode)
                              .format(controller.date),
                        ),
                      ],
                      const SizedBox(height: AppDimensions.generalPadding),
                      item(
                        firstString: LanguageKey.description.tr,
                        secondString: controller.package.name,
                      ),
                      const SizedBox(height: AppDimensions.generalPadding),
                      item(
                        firstString: LanguageKey.bookingType.tr,
                        secondString: controller.package.packageType ==
                                PackageType.timeSlot
                            ? LanguageKey.oneTimeReservation.tr
                            : LanguageKey.subscription.tr,
                      ),
                      const SizedBox(height: AppDimensions.generalPadding),
                      item(
                        firstString: LanguageKey.price.tr,
                        secondString:
                            "${controller.package.price} ${LanguageKey.dirhams.tr}",
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget item({
    required String firstString,
    required String secondString,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          firstString,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          secondString,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
