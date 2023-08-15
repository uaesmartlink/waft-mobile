import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/localization/translation.dart';
import 'package:sport/app/core/models/notification_model.dart';
import 'package:sport/app/core/services/request_mixin.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/utils/intl.dart';
import 'package:sport/app/core/widgets/pagination.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/notifications/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: AppBar(
          toolbarHeight: 100,
          title: Text(
            LanguageKey.notifications.tr,
          ),
        ),
      ),
      body: ScreenSizer(
        builder: (CustomSize customSize) {
          return StateBuilder<NotificationsController>(
            id: "getNotifications",
            onRetryFunction: controller.getNotifications,
            builder: (widgetState, controller) {
              return PaginationBuilder<NotificationsController>(
                id: "getNotifications",
                onRefresh: () async {
                  await controller.getNotifications(RequestType.refresh);
                },
                onRetryFunction: controller.getNotifications,
                onLoadingMore: () async {
                  await controller.getNotifications(RequestType.loadingMore);
                },
                builder: (scrollController) {
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                    itemBuilder: (context, index) {
                      final NotificationModel notification =
                          controller.dataList[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          header(index: index),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: const Offset(1, 2),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.notifications_active,
                                    color: AppColors.primary),
                                title: Text(
                                  notification.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  notification.body,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.fontGray,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
          );
        },
      ),
    );
  }

  Widget header({
    required int index,
  }) {
    final NotificationModel notification = controller.dataList[index];
    return Builder(
      builder: (context) {
        if (index == 0) {
          if (notification.createdAt.sameDay()) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                LanguageKey.today.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                DateFormat.MMMMd(Translation.languageCode)
                    .format(notification.createdAt),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        } else if (!notification.createdAt
            .sameDay(controller.dataList[index - 1].createdAt)) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              DateFormat.MMMMd(Translation.languageCode)
                  .format(notification.createdAt),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
