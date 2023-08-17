import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/modules/main_feature/home/widgets/section.dart';
import 'package:sport/app/modules/main_feature/home/widgets/section_header.dart';

import '../../../../core/localization/language_key.dart';
import '../../../../core/widgets/widget_state.dart';
import '../../search_activities/search_activities_controller.dart';
import '../../shared/constant/home_routes.dart';
import '../home_controller.dart';

class NearbyLocationTabBar extends StatelessWidget {
  const NearbyLocationTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  StateBuilder<HomeController>(
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
    );
  }
}
