import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/activity_type_model.dart';
import 'package:sport/app/core/services/request_mixin.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/cached_network_image.dart';
import 'package:sport/app/core/widgets/pagination.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/activities/widgets/activities_app_bar.dart';
import 'package:sport/app/modules/main_feature/activities/widgets/activities_grid_item.dart';
import 'package:sport/app/modules/main_feature/search_activities/search_activities_controller.dart';
import 'package:sport/app/modules/main_feature/shared/constant/home_routes.dart';

import '../../../../app_constants/app_assets.dart';
import '../../../../app_constants/app_dimensions.dart';
import 'activities_controller.dart';

class ActivitiesView extends GetView<ActivitiesController> {
  const ActivitiesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const PreferredSize(
        preferredSize:  Size(double.infinity, 100),
        child: ActivitiesAppBar(),
      ),
      body: ScreenSizer(
        builder: (CustomSize customSize) {
          return StateBuilder<ActivitiesController>(
            id: "getActivityTypes",
            onRetryFunction: controller.getActivityTypes,
            builder: (widgetState, controller) {
              return PaginationBuilder<ActivitiesController>(
                id: "getActivityTypes",
                onRefresh: () async {
                  await controller.getActivityTypes(RequestType.refresh);
                },
                onRetryFunction: controller.getActivityTypes,
                builder: (scrollController) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(AppDimensions.generalPadding, AppDimensions.generalPadding, AppDimensions.generalPadding, 80),
                    itemBuilder: (context, index) {
                      return ActivityGridItem(activityType: controller.dataList[index]);
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
}
