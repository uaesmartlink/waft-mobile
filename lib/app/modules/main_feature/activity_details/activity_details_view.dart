import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/localization/translation.dart';
import 'package:sport/app/core/models/user_model.dart';
import 'package:sport/app/core/services/request_mixin.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';
import 'package:sport/app/core/widgets/go_login.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/activity_details/activity_details_controller.dart';
import 'package:sport/app/modules/main_feature/activity_details/widgets/about_us_widget.dart';
import 'package:sport/app/modules/main_feature/activity_details/widgets/gallery_widget.dart';
import 'package:sport/app/modules/main_feature/activity_details/widgets/packages_widget.dart';
import 'package:sport/app/modules/main_feature/activity_details/widgets/reviews_widget.dart';
import 'package:sport/app/modules/main_feature/activity_details/widgets/services_widget.dart';
import 'package:sport/app/modules/main_feature/activity_details/widgets/working_hours_widget.dart';
import 'package:sport/app/modules/main_feature/shared/constant/home_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityDetailsView extends GetView<ActivityDetailsController> {
  const ActivityDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: StateBuilder<ActivityDetailsController>(
        id: "getStadia",
        onRetryFunction: controller.getStadia,
        builder: (widgetState, controller) {
          return SafeArea(
            bottom: false,
            child: Scaffold(
              floatingActionButton: floatingActionButton(context),
              floatingActionButtonLocation: controller.tabBarIndex ==
                          controller.tabController!.length - 1 ||
                      DataHelper.user?.browsingType == AccountType.manager
                  ? null
                  : FloatingActionButtonLocation.centerDocked,
              body: ScreenSizer(builder: (CustomSize customSize) {
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Stack(
                      children: [
                        CachedNetworkImage(
                          width: double.infinity,
                          height: 300,
                          imageUrl: controller.activity.image,
                          placeholder: (_, __) => Shimmer.fromColors(
                            baseColor: AppColors.background,
                            highlightColor: AppColors.backgroundTextFilled,
                            child: const SizedBox(
                              width: double.infinity,
                              height: 300,
                            ),
                          ),
                          errorWidget: (_, __, ___) {
                            return const Placeholder();
                          },
                          fit: BoxFit.cover,
                        ),
                        Container(
                          width: double.infinity,
                          height: 300,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black45,
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (Get.previousRoute != "")
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: AppColors.background,
                                    ),
                                  )
                                else
                                  const SizedBox(),
                                if (DataHelper.user?.browsingType !=
                                    AccountType.manager)
                                  GetBuilder<ActivityDetailsController>(
                                    id: "isFavorite",
                                    builder: (controller) {
                                      return controller.saved
                                          ? SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: InkWell(
                                                onTap: controller.toggelSaved,
                                                child: SvgPicture.asset(
                                                  "assets/images/Saved_solid.svg",
                                                  width: 25,
                                                  height: 25,
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: InkWell(
                                                onTap: controller.toggelSaved,
                                                child: SvgPicture.asset(
                                                  "assets/images/Saved_border.svg",
                                                  width: 25,
                                                  height: 25,
                                                  color: AppColors.background,
                                                ),
                                              ),
                                            );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: controller.activity.rating != null ? 260 : 230,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    controller.activity.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(),
                              ],
                            ),
                            SizedBox(height: Translation.isArabic ? 3 : 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  controller.activity.address,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.fontGray,
                                  ),
                                ),
                              ],
                            ),
                            if (controller.activity.rating != null) ...[
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    controller.activity.rating! < 2
                                        ? Icons.star_border_rounded
                                        : controller.activity.rating == 5
                                            ? Icons.star_rounded
                                            : Icons.star_half_rounded,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${controller.activity.rating!.toStringAsFixed(1)} (${controller.activity.reviewCount} ${LanguageKey.reviews.tr})",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.fontGray,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            SizedBox(height: Translation.isArabic ? 6 : 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                actionItem(
                                  icon: Icons.language,
                                  title: LanguageKey.website.tr,
                                  onTap: () async {
                                    launchUrl(
                                      Uri.parse(controller.activity.website),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                ),
                                actionItem(
                                  icon: Icons.location_on_rounded,
                                  title: LanguageKey.seeMaps.tr,
                                  onTap: () async {
                                    launchUrl(
                                      Uri.parse(controller.activity.mapUrl),
                                    );
                                  },
                                ),
                                actionItem(
                                  icon: Icons.share,
                                  title: LanguageKey.share.tr,
                                  onTap: () {
                                    Share.share(
                                        'https://ae.waft.user/activityDetails?activityId=${controller.activity.id}');
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: TabBar(
                        indicatorColor: AppColors.background,
                        automaticIndicatorColorAdjustment: false,
                        controller: controller.tabController!,
                        isScrollable: controller.tabController!.length > 3,
                        onTap: controller.changeSelectedTabBarIndex,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                        tabs: DataHelper.user?.browsingType ==
                                AccountType.manager
                            ? [
                                tabBarItem(
                                  selected: controller.tabBarIndex == 0,
                                  title: LanguageKey.aboutUs.tr,
                                ),
                                tabBarItem(
                                  selected: controller.tabBarIndex ==
                                      controller.tabController!.length - 5,
                                  title: LanguageKey.services.tr,
                                ),
                                tabBarItem(
                                  selected: controller.tabBarIndex ==
                                      controller.tabController!.length - 4,
                                  title: LanguageKey.packages.tr,
                                ),
                                tabBarItem(
                                  selected: controller.tabBarIndex ==
                                      controller.tabController!.length - 3,
                                  title: LanguageKey.workingHours.tr,
                                ),
                                tabBarItem(
                                  selected: controller.tabBarIndex ==
                                      controller.tabController!.length - 2,
                                  title: LanguageKey.gallery.tr,
                                ),
                                tabBarItem(
                                  selected: controller.tabBarIndex ==
                                      controller.tabController!.length - 1,
                                  title: LanguageKey.reviews.tr,
                                ),
                              ]
                            : [
                                tabBarItem(
                                  selected: controller.tabBarIndex == 0,
                                  title: LanguageKey.aboutUs.tr,
                                ),
                                if (controller.activity.services.isNotEmpty)
                                  tabBarItem(
                                    selected: controller.tabBarIndex == 1,
                                    title: LanguageKey.services.tr,
                                  ),
                                if (controller.activity.images.isNotEmpty)
                                  tabBarItem(
                                    selected: controller.tabBarIndex ==
                                        controller.tabController!.length - 2,
                                    title: LanguageKey.gallery.tr,
                                  ),
                                tabBarItem(
                                  selected: controller.tabBarIndex ==
                                      controller.tabController!.length - 1,
                                  title: LanguageKey.reviews.tr,
                                ),
                              ],
                      ),
                    ),
                    SizedBox(
                      height: customSize.screenHeight -
                          (controller.activity.rating != null ? 300 : 270),
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: controller.tabController!,
                        children: DataHelper.user?.browsingType ==
                                AccountType.manager
                            ? [
                                AboutUsWidget(
                                  description: controller.activity.description,
                                  workTimes: controller.activity.workTimes,
                                ),
                                ServicesWidget(
                                  services: controller.activity.services,
                                ),
                                PackagesWidget(
                                  packages: controller.activity.packages,
                                ),
                                WorkingHoursWidget(
                                  workTimes: controller.activity.workTimes,
                                ),
                                GalleryWidget(
                                    images: controller.activity.images),
                                const ReviewsWidget(),
                              ]
                            : [
                                AboutUsWidget(
                                  description: controller.activity.description,
                                  workTimes: controller.activity.workTimes,
                                ),
                                if (controller.activity.services.isNotEmpty)
                                  ServicesWidget(
                                      services: controller.activity.services),
                                if (controller.activity.images.isNotEmpty)
                                  GalleryWidget(
                                      images: controller.activity.images),
                                const ReviewsWidget(),
                              ],
                      ),
                    )
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }

  Widget floatingActionButton(BuildContext context) {
    if (DataHelper.user?.browsingType == AccountType.manager) {
      if (controller.tabBarIndex == 0) {
        return FloatingActionButton(
          onPressed: () async {
            await Get.toNamed(HomeRoutes.addActivityRoute, arguments: {
              "activity": controller.activity,
            });
            controller.getStadia(RequestType.refresh);
          },
          child: const Icon(
            Icons.edit,
            color: AppColors.background,
          ),
        );
      } else if (controller.tabBarIndex == 1) {
        return FloatingActionButton(
          onPressed: () async {
            addServiceDialog(context: context);
          },
          child: const Icon(
            Icons.add,
            color: AppColors.background,
          ),
        );
      } else if (controller.tabBarIndex == 2) {
        return FloatingActionButton(
          onPressed: () async {
            addPackageDialog(context: context);
          },
          child: const Icon(
            Icons.add,
            color: AppColors.background,
          ),
        );
      } else if (controller.tabBarIndex == 3) {
        return FloatingActionButton(
          onPressed: () async {
            addWorkTimeDialog(context: context);
          },
          child: const Icon(
            Icons.add,
            color: AppColors.background,
          ),
        );
      } else if (controller.tabBarIndex == 4) {
        return FloatingActionButton(
          onPressed: () async {
            controller.pickImageGallery();
          },
          child: const Icon(
            Icons.add,
            color: AppColors.background,
          ),
        );
      } else {
        return const SizedBox();
      }
    } else {
      if (controller.tabBarIndex == controller.tabController!.length - 1) {
        return FloatingActionButton(
          onPressed: () {
            if (DataHelper.logedIn) {
              if (controller.checkBooking) {
                reviewDialog(context: context);
              } else {
                AppMessenger.message(LanguageKey.submitReview.tr);
              }
            } else {
              loginBottomSheet(description: LanguageKey.loginToAddReview.tr);
            }
          },
          child: const Icon(
            Icons.message,
            color: AppColors.background,
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 2),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(
                  HomeRoutes.bookAppointmentRoute,
                  arguments: {"activity": controller.activity},
                );
              },
              child: Text(LanguageKey.bookNow.tr),
            ),
          ),
        );
      }
    }
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

  Widget actionItem({
    required IconData icon,
    required String title,
    required void Function() onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.splash,
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
