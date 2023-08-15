import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/review_model.dart';
import 'package:sport/app/core/models/user_model.dart';
import 'package:sport/app/core/services/request_mixin.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';
import 'package:sport/app/core/widgets/elevated_button.dart';
import 'package:sport/app/core/widgets/go_login.dart';
import 'package:sport/app/core/widgets/pagination.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/activity_details/activity_details_controller.dart';

class ReviewsWidget extends GetView<ActivityDetailsController> {
  const ReviewsWidget({this.seeAll = false, super.key});
  final bool seeAll;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: DataHelper.user?.browsingType == AccountType.manager
          ? null
          : seeAll
              ? FloatingActionButton(
                  onPressed: () {
                    if (DataHelper.logedIn) {
                      if (controller.checkBooking) {
                        reviewDialog(context: context);
                      } else {
                        AppMessenger.message(LanguageKey.submitReview.tr);
                      }
                    } else {
                      loginBottomSheet(
                          description: LanguageKey.loginToAddReview.tr);
                    }
                  },
                  child: const Icon(
                    Icons.message,
                    color: AppColors.background,
                  ),
                )
              : null,
      appBar: seeAll
          ? PreferredSize(
              preferredSize: const Size(double.infinity, 100),
              child: AppBar(
                toolbarHeight: 100,
                title: Text(
                  LanguageKey.allReviews.tr,
                ),
              ),
            )
          : null,
      body: StateBuilder<ActivityDetailsController>(
        id: "getReviews",
        onRetryFunction: controller.getReviews,
        builder: (widgetState, controller) {
          return PaginationBuilder<ActivityDetailsController>(
            id: "getReviews",
            onRefresh: () async {
              await controller.getReviews(RequestType.refresh);
            },
            onLoadingMore: seeAll
                ? () async {
                    await controller.getReviews(RequestType.loadingMore);
                  }
                : null,
            onRetryFunction: controller.getReviews,
            builder: (scrollController) {
              return ListView.separated(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                controller: scrollController,
                itemBuilder: (context, index) {
                  if (index == 0 && !seeAll) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              (controller.activity.rating ?? 0) < 2
                                  ? Icons.star_border_rounded
                                  : controller.activity.rating == 5
                                      ? Icons.star_rounded
                                      : Icons.star_half_rounded,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "${controller.activity.rating?.toStringAsFixed(1) ?? ""} (${controller.activity.reviewCount == 0 ? "" : controller.activity.reviewCount} ${LanguageKey.reviews.tr})",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.fontGray,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Get.to(() => const ReviewsWidget(
                                      seeAll: true,
                                    ));
                              },
                              child: Text(
                                LanguageKey.seeAll.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    );
                  } else {
                    final Review review =
                        controller.dataList[index - (seeAll ? 0 : 1)];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        review.user.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.primary),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rate_rounded,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              review.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(review.comment),
                      leading: CircleAvatar(
                        radius: 30,
                        foregroundImage:
                            CachedNetworkImageProvider(review.user.image),
                      ),
                    );
                  }
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
                itemCount: controller.dataList.length + (seeAll ? 0 : 1),
              );
            },
          );
        },
      ),
    );
  }
}

void reviewDialog({
  required BuildContext context,
}) {
  double rating = 4.0;
  TextEditingController textEditingController = TextEditingController();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: AppColors.background,
        child: Container(
          padding: const EdgeInsets.all(30),
          width: MediaQuery.of(context).size.width - 100,
          child: SingleChildScrollView(
            child: StateBuilder<ActivityDetailsController>(
                id: "addReview",
                disableState: true,
                initialWidgetState: WidgetState.loaded,
                builder: (widgetState, controller) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/review.png",
                      ),
                      const SizedBox(height: 20),
                      Text(
                        LanguageKey.leaveReview.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      RatingBar.builder(
                        initialRating: rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        ignoreGestures: widgetState == WidgetState.loading,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star_rate_rounded,
                          color: AppColors.primary,
                        ),
                        onRatingUpdate: (newRating) {
                          rating = newRating;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        maxLines: 2,
                        readOnly: widgetState == WidgetState.loading,
                        controller: textEditingController,
                        minLines: 1,
                        maxLength: 500,
                        onTap: () {
                          if (textEditingController.selection.extent.offset ==
                              0) {
                            textEditingController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: textEditingController.text.length));
                            controller.update(["addReview"]);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: LanguageKey.writeYourReview.tr,
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          counter: const SizedBox(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedStateButton(
                          widgetState: widgetState,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            controller.addReview(
                              rating: rating.toInt(),
                              comment: textEditingController.text,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            backgroundColor: AppColors.primary,
                          ),
                          child: Text(
                            LanguageKey.writeReview.tr,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                            LanguageKey.cancel.tr,
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
