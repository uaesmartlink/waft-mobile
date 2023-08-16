import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/localization/translation.dart';
import 'package:sport/app/core/models/user_model.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';
import 'package:sport/app/core/widgets/go_login.dart';
import 'package:sport/app/core/widgets/no_internet.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/home/widgets/section.dart';
import 'package:sport/app/modules/main_feature/home/widgets/section_header.dart';
import 'package:sport/app/modules/main_feature/profile/profile_view.dart';
import 'package:sport/app/modules/main_feature/search_activities/search_activities_controller.dart';
import 'package:sport/app/modules/main_feature/shared/constant/home_routes.dart';
import 'package:sport/app_constants/app_dimensions.dart';

import '../../../../app_constants/app_assets.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
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
          title: const Text(
            "WAFT",
          ),
          actions: [
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {
                if (DataHelper.logedIn) {
                  Get.toNamed(HomeRoutes.notificationsRoute);
                } else {
                  loginBottomSheet(
                      description: LanguageKey.loginToViewNotifications.tr);
                }
              },
              icon: SvgPicture.asset(
                AppAssets.notifications,
                width: 25,
                height: 25,
              ),
            ),
            IconButton(
              onPressed: () {
                if (DataHelper.logedIn) {
                  Get.toNamed(HomeRoutes.favoritesRoute);
                } else {
                  loginBottomSheet(
                      description: LanguageKey.loginToViewFavorites.tr);
                }
              },
              icon: SvgPicture.asset(
                AppAssets.bookMarkOutlined,
                width: 25,
                height: 25,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
      body: ScreenSizer(
        builder: (customSize) {
          return Column(
            children: [
              GetBuilder<HomeController>(
                id: "hi",
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.generalPadding),
                    child: SizedBox(
                      height: 125,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${LanguageKey.hi.tr}, ${DataHelper.user?.name.substring(0, DataHelper.user!.name.contains(" ") ? DataHelper.user!.name.indexOf(" ") : null) ?? ""} 👋",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: Translation.isArabic ? 5 : AppDimensions.generalPadding),
                          TextField(
                            readOnly: true,
                            onTap: () {
                              Get.toNamed(
                                HomeRoutes.searchActivitiesRoute,
                                arguments: {"searchMode": SearchMode.search},
                              );
                            },
                            decoration: InputDecoration(
                              hintText: LanguageKey.search.tr,
                              prefixIcon: const Icon(Icons.search),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: customSize.screenHeight - 125,
                child: RefreshIndicator(
                  onRefresh: controller.refreshHomeData,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: AppDimensions.generalPadding),
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                      children: [
                        const SizedBox(height: AppDimensions.generalPadding),
                        GetBuilder<HomeController>(
                          id: "Banners",
                          builder: (controller) {
                            if (controller.banners != null &&
                                controller.banners!.isEmpty) {
                              return const SizedBox();
                            } else {
                              return Column(
                                children: [
                                  StateBuilder<HomeController>(
                                    id: "getBanners",
                                    builder: (widgetState, controller) {
                                      return CarouselSlider(
                                        items: (controller.banners ?? [])
                                            .map(
                                              (banner) => GestureDetector(
                                                onTap: () {
                                                  Uri url =
                                                      Uri.parse(banner.link);
                                                  String? activityId =
                                                      url.queryParameters[
                                                          'activityId'];

                                                  String? stadiumId =
                                                      url.queryParameters[
                                                          'stadiumId'];

                                                  if (stadiumId != null) {
                                                    Get.toNamed(
                                                      HomeRoutes
                                                          .activityDetailsRoute,
                                                      parameters: {
                                                        "activityId": stadiumId,
                                                      },
                                                    );
                                                  } else if (activityId !=
                                                      null) {
                                                    Get.toNamed(
                                                      HomeRoutes
                                                          .searchActivitiesRoute,
                                                      arguments: {
                                                        "searchMode":
                                                            SearchMode.category,
                                                        "bannerName":
                                                            banner.title,
                                                        "activityTypeId":
                                                            int.parse(
                                                                activityId),
                                                      },
                                                    );
                                                  } else if (banner.link
                                                      .contains("bePartner")) {
                                                    if (DataHelper.logedIn) {
                                                      if (DataHelper
                                                              .user!.role ==
                                                          AccountType.user) {
                                                        partnerDialog(
                                                            context: context);
                                                      } else {
                                                        AppMessenger.message(
                                                            LanguageKey
                                                                .alreadyPartner
                                                                .tr);
                                                      }
                                                    } else {
                                                      loginBottomSheet(
                                                          description: LanguageKey
                                                              .loginToBeWaftPartner
                                                              .tr);
                                                    }
                                                  }
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: CachedNetworkImage(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    imageUrl: banner.image,
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
                                            )
                                            .toList(),
                                        options: CarouselOptions(
                                          aspectRatio: 16 / 7,
                                          viewportFraction: 0.8,
                                          initialPage: 0,
                                          enableInfiniteScroll: true,
                                          reverse: false,
                                          autoPlay: true,
                                          autoPlayInterval:
                                              const Duration(seconds: 3),
                                          autoPlayAnimationDuration:
                                              const Duration(seconds: 800),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,
                                          enlargeFactor: 0.3,
                                          onPageChanged: (index, reason) {
                                            controller
                                                .changeCarouselSliderIndex(
                                                    index);
                                          },
                                          scrollDirection: Axis.horizontal,
                                        ),
                                      );
                                    },
                                    errorView: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              (1 / (16 / 7)),
                                      child: NoInternetConnection(
                                        onRetryFunction: controller.getBanners,
                                      ),
                                    ),
                                    loadingView: CarouselSlider(
                                      items: [1, 1, 1]
                                          .map(
                                            (banner) => ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Shimmer.fromColors(
                                                  baseColor:
                                                      AppColors.codeInput,
                                                  highlightColor:
                                                      AppColors.background,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color:
                                                          AppColors.codeInput,
                                                    ),
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                )),
                                          )
                                          .toList(),
                                      options: CarouselOptions(
                                        aspectRatio: 16 / 7,
                                        viewportFraction: 0.8,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay: true,
                                        autoPlayInterval:
                                            const Duration(seconds: 3),
                                        autoPlayAnimationDuration:
                                            const Duration(seconds: 800),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enlargeCenterPage: true,
                                        enlargeFactor: 0.3,
                                        onPageChanged: (index, reason) {
                                          controller
                                              .changeCarouselSliderIndex(index);
                                        },
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GetBuilder<HomeController>(
                                    id: "SmoothPageIndicator",
                                    builder: (context) {
                                      return SmoothPageIndicator(
                                        count: controller.banners?.length ?? 0,
                                        controller: PageController(
                                            initialPage:
                                                controller.carouselSliderIndex),
                                        axisDirection: Axis.horizontal,
                                        effect: const ExpandingDotsEffect(
                                          spacing: 8.0,
                                          radius: 15,
                                          dotWidth: 10,
                                          dotHeight: 8,
                                          paintStyle: PaintingStyle.fill,
                                          dotColor: AppColors.fontGray,
                                          activeDotColor: AppColors.primary,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: AppDimensions.generalPadding),
                                  const Divider(
                                    endIndent: 20,
                                    indent: 20,
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        StateBuilder<HomeController>(
                          id: "getNearby",
                          disableState: true,
                          builder: (widgetState, controller) {
                            return SectionWidget(
                              onSeeAll: () {
                                Get.toNamed(
                                  HomeRoutes.searchActivitiesRoute,
                                  arguments: {
                                    "searchMode": SearchMode.city,
                                    "cities": controller.cities,
                                    "selectedCity": controller.selectedCity,
                                  },
                                );
                              },
                              onTap: (activity) {
                                Get.toNamed(
                                  HomeRoutes.activityDetailsRoute,
                                  parameters: {
                                    "activityId": activity.id.toString(),
                                  },
                                );
                              },
                              onRemove: (favoriteId) async {
                                return controller.removeFromFavorites(
                                    favoriteId: favoriteId);
                              },
                              onSave: (activity) async {
                                return controller.addToFavorites(
                                    activity: activity);
                              },
                              items: controller.nearbyActivities.length > 3
                                  ? controller.nearbyActivities.sublist(0, 3)
                                  : controller.nearbyActivities,
                              selectedHeaderItem:
                                  controller.selectedCity == null
                                      ? null
                                      : SectionHeaderItem(
                                          id: controller.selectedCity!.id,
                                          title: controller.selectedCity!.name,
                                        ),
                              headerItems: controller.cities
                                  .map(
                                    (city) => SectionHeaderItem(
                                      id: city.id,
                                      title: city.name,
                                    ),
                                  )
                                  .toList(),
                              onSelectHeaderItem: controller.changeSelectedCity,
                              widgetState: widgetState,
                              title: LanguageKey.nearbyYourLocation.tr,
                              onRetryFunction: controller.getNearby,
                            );
                          },
                        ),
                        const SizedBox(height: AppDimensions.generalPadding),
                        StateBuilder<HomeController>(
                          id: "getMostPopular",
                          disableState: true,
                          builder: (widgetState, controller) {
                            return SectionWidget(
                              items: controller.mostPopularActivities.length > 3
                                  ? controller.mostPopularActivities
                                      .sublist(0, 3)
                                  : controller.mostPopularActivities,
                              onSeeAll: () {
                                Get.toNamed(
                                  HomeRoutes.searchActivitiesRoute,
                                  arguments: {
                                    "searchMode": SearchMode.category,
                                    "activityTypes": controller.activityTypes,
                                    "selectedActivityType":
                                        controller.selectedActivityType,
                                  },
                                );
                              },
                              onTap: (activity) {
                                Get.toNamed(
                                  HomeRoutes.activityDetailsRoute,
                                  parameters: {
                                    "activityId": activity.id.toString()
                                  },
                                );
                              },
                              onSave: (activity) async {
                                return controller.addToFavorites(
                                    activity: activity);
                              },
                              onRemove: (favoriteId) async {
                                return controller.removeFromFavorites(
                                    favoriteId: favoriteId);
                              },
                              selectedHeaderItem: controller
                                          .selectedActivityType ==
                                      null
                                  ? null
                                  : SectionHeaderItem(
                                      id: controller.selectedActivityType!.id,
                                      title:
                                          controller.selectedActivityType!.name,
                                    ),
                              headerItems: controller.activityTypes
                                  .map(
                                    (activity) => SectionHeaderItem(
                                      id: activity.id,
                                      title: activity.name,
                                    ),
                                  )
                                  .toList(),
                              onSelectHeaderItem:
                                  controller.changeSelectedActivityType,
                              onRetryFunction: controller.getMostPopular,
                              widgetState: widgetState,
                              title: LanguageKey.mostPopular.tr,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
