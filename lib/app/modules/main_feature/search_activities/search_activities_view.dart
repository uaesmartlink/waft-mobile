import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/services/request_mixin.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/activity_item.dart';
import 'package:sport/app/core/widgets/pagination.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/home/widgets/section_header.dart';
import 'package:sport/app/modules/main_feature/search_activities/search_activities_controller.dart';
import 'package:sport/app/modules/main_feature/shared/constant/home_routes.dart';

import '../../../../app_constants/app_assets.dart';

class SearchActivitiesView extends GetView<SearchActivitiesController> {
  const SearchActivitiesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: AppBar(
          toolbarHeight: 100,
          title: Builder(
            builder: (context) {
              switch (controller.searchMode) {
                case SearchMode.category:
                  return Text(
                    controller.activityTypes.isNotEmpty
                        ? LanguageKey.mostPopular.tr
                        : controller.selectedActivityType?.name ??
                            controller.bannerName ??
                            "",
                  );
                case SearchMode.city:
                  return Text(
                    LanguageKey.nearbyYourLocation.tr,
                  );
                case SearchMode.search:
                  return StatefulBuilder(builder: (context, setState) {
                    return TextField(
                      autofocus: true,
                      onTap: () {
                        if (controller.textEditingController.selection.extent
                                .offset ==
                            0) {
                          controller.textEditingController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: controller
                                      .textEditingController.text.length));
                          setState(() {});
                        }
                      },
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        controller.getActivities();
                      },
                      controller: controller.textEditingController,
                      decoration: InputDecoration(
                        hintText: LanguageKey.search.tr,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            filterBottomSheet();
                          },
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: SvgPicture.asset(
                                AppAssets.filter,
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
              }
            },
          ),
        ),
      ),
      body: ScreenSizer(
        constHeight:
            controller.activityTypes.isNotEmpty || controller.cities.isNotEmpty
                ? 40
                : 0,
        builder: (CustomSize customSize) {
          return Column(
            children: [
              GetBuilder<SearchActivitiesController>(
                id: "header",
                builder: (controller) {
                  if (controller.selectedCity != null &&
                      controller.searchMode != SearchMode.search) {
                    return SizedBox(
                      height: 40,
                      child: StateBuilder<SearchActivitiesController>(
                        id: "getRegions",
                        builder: (widgetState, controller) {
                          return header(
                            items: controller.regions
                                .map(
                                  (region) => SectionHeaderItem(
                                    id: region.id,
                                    title: region.name,
                                  ),
                                )
                                .toList(),
                            selectedItem: controller.selectedRegion == null
                                ? null
                                : SectionHeaderItem(
                                    id: controller.selectedRegion!.id,
                                    title: controller.selectedRegion!.name,
                                  ),
                            onSelectItem: controller.changeSelectedRegion,
                          );
                        },
                        loadingView: ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(width: 10);
                          },
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: AppColors.codeInput,
                              highlightColor: AppColors.background,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: AppColors.codeInput,
                                ),
                                width: 50 * (index % 3 + 1),
                                height: 40,
                              ),
                            );
                          },
                        ),
                        errorView: Center(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.secondry,
                              ),
                            ),
                            onPressed: () {
                              controller.getRegions();
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: AppColors.secondry,
                            ),
                            label: Text(
                              LanguageKey.tryAgain.tr,
                              style: const TextStyle(
                                color: AppColors.secondry,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (controller.activityTypes.isNotEmpty) {
                    return header(
                      items: controller.activityTypes
                          .map(
                            (activityType) => SectionHeaderItem(
                              id: activityType.id,
                              title: activityType.name,
                            ),
                          )
                          .toList(),
                      selectedItem: controller.selectedActivityType == null
                          ? null
                          : SectionHeaderItem(
                              id: controller.selectedActivityType!.id,
                              title: controller.selectedActivityType!.name,
                            ),
                      onSelectItem: controller.changeSelectedActivityType,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              SizedBox(
                height: customSize.screenHeight,
                child: StateBuilder<SearchActivitiesController>(
                  id: "getActivities",
                  initialWidgetState: controller.searchMode == SearchMode.search
                      ? WidgetState.loaded
                      : WidgetState.loading,
                  onRetryFunction: controller.getActivities,
                  builder: (widgetState, controller) {
                    return PaginationBuilder<SearchActivitiesController>(
                      id: "getActivities",
                      onRefresh: () async {
                        await controller.getActivities(RequestType.refresh);
                      },
                      onRetryFunction: controller.getActivities,
                      onLoadingMore: () async {
                        await controller.getActivities(RequestType.loadingMore);
                      },
                      builder: (scrollController) {
                        return ListView.separated(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                          itemBuilder: (context, index) {
                            final Activity activity =
                                controller.dataList[index];
                            return InkWell(
                              onTap: () {
                                Get.toNamed(
                                  HomeRoutes.activityDetailsRoute,
                                  parameters: {
                                    "activityId": activity.id.toString()
                                  },
                                );
                              },
                              child: ActivityItem(
                                title: activity.name,
                                address: activity.address,
                                imageUrl: activity.image,
                                saved: activity.isFavorite,
                                rating: activity.rating,
                                onSave: () async {
                                  return controller.addToFavorites(
                                    activity: activity,
                                  );
                                },
                                onRemove: () async {
                                  return controller.removeFromFavorites(
                                    favoriteId: activity.favoriteId,
                                  );
                                },
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 20);
                          },
                          itemCount: controller.dataList.length,
                        );
                      },
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget header({
    required List<SectionHeaderItem> items,
    required SectionHeaderItem? selectedItem,
    required void Function(int) onSelectItem,
  }) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              onSelectItem(items[index].id);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: items[index] == selectedItem
                    ? AppColors.primary
                    : AppColors.codeInput,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                  child: Text(
                items[index].title,
                style: TextStyle(
                  color: items[index] == selectedItem
                      ? AppColors.background
                      : AppColors.font,
                ),
              )),
            ),
          );
        },
      ),
    );
  }

  void filterBottomSheet() {
    controller.getActivityTypes();
    controller.getCities();
    Get.bottomSheet(
      ScreenSizer(
          constWidth: 40,
          builder: (customSize) {
            return Container(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              width: double.infinity,
              child: GetBuilder<SearchActivitiesController>(
                  id: "filterBottomSheet",
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LanguageKey.filter.tr,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Divider(),
                              const SizedBox(height: 10),
                              Text(
                                LanguageKey.category.tr,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: StateBuilder<SearchActivitiesController>(
                            id: "getActivityTypes",
                            builder: (widgetState, controller) {
                              return header(
                                items: controller.filterActivityTypes
                                    .map(
                                      (activityType) => SectionHeaderItem(
                                        id: activityType.id,
                                        title: activityType.name,
                                      ),
                                    )
                                    .toList(),
                                selectedItem:
                                    controller.filterSelectedActivityType ==
                                            null
                                        ? null
                                        : SectionHeaderItem(
                                            id: controller
                                                .filterSelectedActivityType!.id,
                                            title: controller
                                                .filterSelectedActivityType!
                                                .name,
                                          ),
                                onSelectItem:
                                    controller.changeFilterSelectedActivityType,
                              );
                            },
                            loadingView: ListView.separated(
                              separatorBuilder: (context, index) {
                                return const SizedBox(width: 10);
                              },
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: AppColors.codeInput,
                                  highlightColor: AppColors.background,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: AppColors.codeInput,
                                    ),
                                    width: 50 * (index % 3 + 1),
                                    height: 40,
                                  ),
                                );
                              },
                            ),
                            errorView: Center(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.secondry,
                                  ),
                                ),
                                onPressed: controller.getActivityTypes,
                                icon: const Icon(
                                  Icons.refresh,
                                  color: AppColors.secondry,
                                ),
                                label: Text(
                                  LanguageKey.tryAgain.tr,
                                  style: const TextStyle(
                                    color: AppColors.secondry,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                LanguageKey.city.tr,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: StateBuilder<SearchActivitiesController>(
                            id: "getCities",
                            builder: (widgetState, controller) {
                              return header(
                                items: controller.cities
                                    .map(
                                      (city) => SectionHeaderItem(
                                        id: city.id,
                                        title: city.name,
                                      ),
                                    )
                                    .toList(),
                                selectedItem: controller.selectedCity == null
                                    ? null
                                    : SectionHeaderItem(
                                        id: controller.selectedCity!.id,
                                        title: controller.selectedCity!.name,
                                      ),
                                onSelectItem: (cityId) {
                                  controller.changeSelectedCity(cityId);
                                  controller.getRegions();
                                },
                              );
                            },
                            loadingView: ListView.separated(
                              separatorBuilder: (context, index) {
                                return const SizedBox(width: 10);
                              },
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: AppColors.codeInput,
                                  highlightColor: AppColors.background,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: AppColors.codeInput,
                                    ),
                                    width: 50 * (index % 3 + 1),
                                    height: 40,
                                  ),
                                );
                              },
                            ),
                            errorView: Center(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.secondry,
                                  ),
                                ),
                                onPressed: () {
                                  controller.getCities();
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  color: AppColors.secondry,
                                ),
                                label: Text(
                                  LanguageKey.tryAgain.tr,
                                  style: const TextStyle(
                                    color: AppColors.secondry,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (controller.selectedCity != null) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  LanguageKey.region.tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: StateBuilder<SearchActivitiesController>(
                              id: "getRegions",
                              builder: (widgetState, controller) {
                                return header(
                                  items: controller.regions
                                      .map(
                                        (region) => SectionHeaderItem(
                                          id: region.id,
                                          title: region.name,
                                        ),
                                      )
                                      .toList(),
                                  selectedItem: controller.selectedRegion ==
                                          null
                                      ? null
                                      : SectionHeaderItem(
                                          id: controller.selectedRegion!.id,
                                          title:
                                              controller.selectedRegion!.name,
                                        ),
                                  onSelectItem: controller.changeSelectedRegion,
                                );
                              },
                              loadingView: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return const SizedBox(width: 10);
                                },
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                itemCount: 6,
                                itemBuilder: (context, index) {
                                  return Shimmer.fromColors(
                                    baseColor: AppColors.codeInput,
                                    highlightColor: AppColors.background,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: AppColors.codeInput,
                                      ),
                                      width: 50 * (index % 3 + 1),
                                      height: 40,
                                    ),
                                  );
                                },
                              ),
                              errorView: Center(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: AppColors.secondry,
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.getRegions();
                                  },
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: AppColors.secondry,
                                  ),
                                  label: Text(
                                    LanguageKey.tryAgain.tr,
                                    style: const TextStyle(
                                      color: AppColors.secondry,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                LanguageKey.rating.tr,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        GetBuilder<SearchActivitiesController>(
                            id: "Rating",
                            builder: (context) {
                              return SizedBox(
                                height: 40,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  children: [1.0, 2.0, 3.0, 4.0, 5.0]
                                      .map(
                                        (rate) => InkWell(
                                          onTap: () {
                                            controller
                                                .changeFilterSelectedRate(rate);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: rate ==
                                                      controller.selectedRate
                                                  ? AppColors.primary
                                                  : AppColors.codeInput,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.star_rate_rounded,
                                                  color: rate ==
                                                          controller
                                                              .selectedRate
                                                      ? AppColors.background
                                                      : AppColors.font,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  rate.toString(),
                                                  style: TextStyle(
                                                    color: rate ==
                                                            controller
                                                                .selectedRate
                                                        ? AppColors.background
                                                        : AppColors.font,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            }),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 50,
                              width: customSize.screenWidth / 2 - 10,
                              child: ElevatedButton(
                                onPressed: controller.resetFilter,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.splash,
                                  elevation: 0,
                                ),
                                child: Text(
                                  LanguageKey.reset.tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: customSize.screenWidth / 2 - 10,
                              child: ElevatedButton(
                                onPressed: controller.applyFilter,
                                child: Text(
                                  LanguageKey.applyFilter.tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
            );
          }),
      isDismissible: true,
      enableDrag: true,
      enterBottomSheetDuration: const Duration(milliseconds: 200),
      isScrollControlled: true,
    );
  }
}
