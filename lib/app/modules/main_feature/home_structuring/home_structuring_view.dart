import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/user_model.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/modules/main_feature/activities/activities_view.dart';
import 'package:sport/app/modules/main_feature/bookings/bookings_view.dart';
import 'package:sport/app/modules/main_feature/home/home_view.dart';
import 'package:sport/app/modules/main_feature/manager_activities/manager_activities_view.dart';
import 'package:sport/app/modules/main_feature/manager_bookings/manager_bookings_view.dart';
import 'package:sport/app/modules/main_feature/manager_home/manager_home_view.dart';
import 'package:sport/app/modules/main_feature/profile/profile_view.dart';
import 'package:sport/app_constants/app_assets.dart';

import 'home_structuring_controller.dart';

class HomeStructuringView extends GetView<HomeStructuringController> {
  const HomeStructuringView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: DataHelper.user?.browsingType == AccountType.manager
            ? const [
                ManagerHomeView(),
                ManagerActivitiesView(),
                ManagerBookingsView(),
                ProfileView(),
              ]
            : const [
                HomeView(),
                ActivitiesView(),
                BookingsView(),
                ProfileView(),
              ],
      ),
      bottomNavigationBar: GetBuilder<HomeStructuringController>(
          id: "BottomNavigationBar",
          builder: (context) {
            return BottomNavigationBar(
              onTap: DataHelper.user?.browsingType == AccountType.manager
                  ? controller.changeManagerPageIndex
                  : controller.changePageIndex,
              currentIndex: controller.pageIndex,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.fontGray,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppAssets.home,
                    width: 30,
                    height: 30,
                    color: controller.pageIndex == 0 ? AppColors.primary : null,
                  ),
                  label: LanguageKey.home.tr,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppAssets.activities,
                    width: 30,
                    height: 30,
                    color: controller.pageIndex == 1 ? AppColors.primary : null,
                  ),
                  label: LanguageKey.activities.tr,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppAssets.subscription,
                    width: 30,
                    height: 30,
                    color: controller.pageIndex == 2 ? AppColors.primary : null,
                  ),
                  label: LanguageKey.bookings.tr,
                ),
                // BottomNavigationBarItem(
                //   icon: SvgPicture.asset(
                //     AppAssets.subscription,
                //     width: 30,
                //     height: 30,
                //     color: controller.pageIndex == 3 ? AppColors.primary : null,
                //   ),
                //   label: "Subscriptions",
                // ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppAssets.profile,
                    width: 30,
                    height: 30,
                    color: controller.pageIndex == 3 ? AppColors.primary : null,
                  ),
                  label: LanguageKey.profile.tr,
                ),
              ],
            );
          }),
    );
  }
}
