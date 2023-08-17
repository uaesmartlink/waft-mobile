import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../app_constants/app_dimensions.dart';
import '../../../../core/helpers/data_helper.dart';
import '../../../../core/localization/language_key.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/app_messenger.dart';
import '../../../../core/widgets/go_login.dart';
import '../../../../core/widgets/no_internet.dart';
import '../../../../core/widgets/widget_state.dart';
import '../../profile/profile_view.dart';
import '../../search_activities/search_activities_controller.dart';
import '../../shared/constant/home_routes.dart';
import '../home_controller.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<HomeController>(
      id: "Banners",
      builder: (controller) {
        if (controller.banners != null &&
            controller.banners!.isEmpty) {
          return const SizedBox();
        }
        else {
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
    );
  }
}
