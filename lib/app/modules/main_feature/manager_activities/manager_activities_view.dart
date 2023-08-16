import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/services/request_mixin.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/pagination.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/manager_activities/widgets/activity_item.dart';
import 'package:sport/app/modules/main_feature/shared/constant/home_routes.dart';
import 'package:sport/app_constants/app_assets.dart';

import 'manager_activities_controller.dart';

class ManagerActivitiesView extends GetView<ManagerActivitiesController> {
  const ManagerActivitiesView({Key? key}) : super(key: key);
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
          title: Text(
            LanguageKey.activities.tr,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.toNamed(HomeRoutes.addActivityRoute);
          controller.getManagerActivity(RequestType.refresh);
        },
        child: const Icon(
          Icons.add,
          color: AppColors.background,
        ),
      ),
      body: ScreenSizer(
        builder: (CustomSize customSize) {
          return StateBuilder<ManagerActivitiesController>(
            id: "getManagerActivity",
            onRetryFunction: controller.getManagerActivity,
            builder: (widgetState, controller) {
              return PaginationBuilder<ManagerActivitiesController>(
                id: "getManagerActivity",
                onRefresh: () async {
                  await controller.getManagerActivity(RequestType.refresh);
                },
                onRetryFunction: controller.getManagerActivity,
                builder: (scrollController) {
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                    itemCount: controller.dataList.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 20);
                    },
                    itemBuilder: (context, index) {
                      final Activity activity = controller.dataList[index];
                      return ManagerActivityItem(activity: activity);
                    },
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
