import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/services/request_mixin.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/activity_item.dart';
import 'package:sport/app/core/widgets/pagination.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/favorites/favorites_controller.dart';
import 'package:sport/app/modules/main_feature/home/widgets/section_header.dart';
import 'package:sport/app/modules/main_feature/shared/constant/home_routes.dart';

import '../../../../app_constants/app_dimensions.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: AppBar(
          toolbarHeight: 100,
          title: Text(
            LanguageKey.favorites.tr,
          ),
        ),
      ),
      body: ScreenSizer(
        builder: (CustomSize customSize) {
          return StateBuilder<FavoritesController>(
            id: "getFavoriteStadiums",
            onRetryFunction: controller.getFavoriteStadiums,
            builder: (widgetState, controller) {
              return PaginationBuilder<FavoritesController>(
                id: "getFavoriteStadiums",
                onRefresh: () async {
                  await controller.getFavoriteStadiums(RequestType.refresh);
                },
                onRetryFunction: controller.getFavoriteStadiums,
                onLoadingMore: () async {
                  await controller.getFavoriteStadiums(RequestType.loadingMore);
                },
                builder: (scrollController) {
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(AppDimensions.generalPadding, AppDimensions.generalPadding, AppDimensions.generalPadding, 80),
                    itemBuilder: (context, index) {
                      final Activity activity = controller.dataList[index];
                      return InkWell(
                        onTap: () {
                          Get.toNamed(
                            HomeRoutes.activityDetailsRoute,
                            parameters: {"activityId": activity.id.toString()},
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
                      return const SizedBox(height: AppDimensions.generalPadding);
                    },
                    itemCount: controller.dataList.length,
                  );
                },
              );
            },
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
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.generalPadding),
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
}
