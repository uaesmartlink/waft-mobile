import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/localization/translation.dart';
import 'package:sport/app/core/models/package_model.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/elevated_button.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/review_summary/review_summary_controller.dart';
import 'package:sport/app_constants/app_dimensions.dart';

class ReviewSummaryView extends GetView<ReviewSummaryController> {
  const ReviewSummaryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: AppBar(
          toolbarHeight: 100,
          title: Text(controller.fromBookings
              ? LanguageKey.summary.tr
              : LanguageKey.reviewSummary.tr),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(AppDimensions.generalPadding, 0, AppDimensions.generalPadding, 2),
        child: StateBuilder<ReviewSummaryController>(
            id: "bookStadium",
            disableState: true,
            initialWidgetState: WidgetState.loaded,
            builder: (widgetState, controller) {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: controller.fromBookings
                    ? ElevatedStateButton(
                        widgetState: widgetState,
                        onPressed: () {
                          controller.savePDF();
                        },
                        child: Text(LanguageKey.saveAsPDF.tr),
                      )
                    : ElevatedStateButton(
                        widgetState: widgetState,
                        onPressed: () {
                          controller.bookStadium();
                        },
                        child: Text(LanguageKey.confirmPayment.tr),
                      ),
              );
            }),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.generalPadding),
        children: [
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
                  secondString: DateFormat.yMMMMd(Translation.languageCode)
                      .format(controller.date),
                ),
                if (controller.selectedPackage.packageType ==
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
                  secondString: controller.selectedPackage.name,
                ),
                const SizedBox(height: AppDimensions.generalPadding),
                item(
                  firstString: LanguageKey.bookingType.tr,
                  secondString: controller.selectedPackage.packageType ==
                          PackageType.timeSlot
                      ? LanguageKey.oneTimeReservation.tr
                      : LanguageKey.subscription.tr,
                ),
                const SizedBox(height: AppDimensions.generalPadding),
                item(
                  firstString: LanguageKey.price.tr,
                  secondString:
                      "${controller.selectedPackage.price} ${LanguageKey.dirhams.tr}",
                ),
              ],
            ),
          ),
        ],
      ),
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
