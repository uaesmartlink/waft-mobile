import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/go_login.dart';
import 'package:sport/app/core/widgets/no_internet.dart';
import 'package:sport/app/core/widgets/shimmer_widget.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/search_activities/search_activities_controller.dart';
import 'package:sport/app/modules/main_feature/shared/constant/home_routes.dart';

import '../../../../app_constants/app_assets.dart';
import '../../../../app_constants/app_dimensions.dart';
import 'manager_home_controller.dart';

class ManagerHomeView extends GetView<ManagerHomeController> {
  const ManagerHomeView({Key? key}) : super(key: key);
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
            const SizedBox(width: 10),
          ],
        ),
      ),
      body: ScreenSizer(
        builder: (customSize) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GetBuilder<ManagerHomeController>(
                id: "hi",
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Text(
                        "${LanguageKey.hi.tr}, ${DataHelper.user?.name.substring(0, DataHelper.user!.name.contains(" ") ? DataHelper.user!.name.indexOf(" ") : null) ?? ""} 👋",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: customSize.screenHeight - 50,
                child: RefreshIndicator(
                  onRefresh: controller.refreshManagerHomeData,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        GetBuilder<ManagerHomeController>(
                          id: "Banners",
                          builder: (controller) {
                            if (controller.banners != null &&
                                controller.banners!.isEmpty) {
                              return const SizedBox();
                            } else {
                              return Column(
                                children: [
                                  StateBuilder<ManagerHomeController>(
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
                                  GetBuilder<ManagerHomeController>(
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
                                  const SizedBox(height: 20),
                                ],
                              );
                            }
                          },
                        ),
                        StateBuilder<ManagerHomeController>(
                          id: "getAllStatistics",
                          builder: (widgetState, controller) {
                            return GridView(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(AppDimensions.generalPadding),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                              children: [
                                widget(
                                    title: LanguageKey.totalAmount.tr,
                                    amount:
                                        "${controller.allStatistics.totalAmount} ${LanguageKey.dirhams.tr}"),
                                widget(
                                    title: LanguageKey.totalBookings.tr,
                                    amount: controller
                                        .allStatistics.totalBookings
                                        .toString()),
                                widget(
                                  title: LanguageKey.completed.tr,
                                  amount: controller
                                      .allStatistics.completedBookings
                                      .toString(),
                                ),
                                widget(
                                    title: LanguageKey.canceled.tr,
                                    amount: controller
                                        .allStatistics.canceledBookings
                                        .toString()),
                              ],
                            );
                          },
                          loadingView: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(AppDimensions.generalPadding),
                            shrinkWrap: true,
                            itemCount: 4,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemBuilder: (context, index) {
                              return ShimmerWidget(
                                baseColor: AppColors.codeInput,
                                highlightColor: AppColors.fontGray,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                height: double.infinity,
                                width: double.infinity,
                              );
                            },
                          ),
                          errorView: SizedBox(
                            height: 200,
                            child: NoInternetConnection(
                              onRetryFunction: controller.getAllStatistics,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: StateBuilder<ManagerHomeController>(
                            id: "getStatistics",
                            builder: (widgetState, controller) {
                              return Container(
                                height: 200,
                                padding: const EdgeInsets.all(AppDimensions.generalPadding),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        timeFramWidget(
                                          timeFram: "last_day",
                                          timeFramName: LanguageKey.d.tr,
                                        ),
                                        const SizedBox(width: 10),
                                        timeFramWidget(
                                          timeFram: "last_week",
                                          timeFramName: LanguageKey.w.tr,
                                        ),
                                        const SizedBox(width: 10),
                                        timeFramWidget(
                                          timeFram: "last_month",
                                          timeFramName: LanguageKey.m.tr,
                                        ),
                                        const SizedBox(width: 10),
                                        timeFramWidget(
                                          timeFram: "last_year",
                                          timeFramName: LanguageKey.y.tr,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 110,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SvgPicture.asset(
                                                      AppAssets.cart,
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      LanguageKey.bookings.tr,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  controller
                                                      .statistics.todayBookings
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: AppColors.fontGray,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                child: VerticalDivider(
                                                  color: AppColors.fontGray,
                                                ),
                                              ),
                                              Text("VS"),
                                              SizedBox(
                                                height: 40,
                                                child: VerticalDivider(
                                                  color: AppColors.fontGray,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      LanguageKey.amount.tr,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    SvgPicture.asset(
                                                      AppAssets.amount,
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  "${controller.statistics.totalAmount} ${LanguageKey.dirhams.tr}",
                                                  style: const TextStyle(
                                                    color: AppColors.fontGray,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            loadingView: Container(
                              height: 200,
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
                              child: ShimmerWidget(
                                baseColor: AppColors.codeInput,
                                highlightColor: AppColors.fontGray,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                height: double.infinity,
                                width: double.infinity,
                              ),
                            ),
                            errorView: SizedBox(
                              height: 200,
                              child: NoInternetConnection(
                                onRetryFunction: controller.getAllStatistics,
                              ),
                            ),
                          ),
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

  Widget timeFramWidget({
    required String timeFram,
    required String timeFramName,
  }) {
    return InkWell(
      onTap: () {
        controller.timePeriod = timeFram;
        controller.getStatistics();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: controller.timePeriod == timeFram
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                ),
              )
            : null,
        child: Center(
            child: Text(
          timeFramName,
          style: controller.timePeriod == timeFram
              ? const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                )
              : null,
        )),
      ),
    );
  }

  Widget widget({
    required String title,
    required String amount,
  }) {
    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            AppAssets.money,
            width: 50,
            height: 50,
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.fontGray,
            ),
          ),
        ],
      ),
    );
  }
}
