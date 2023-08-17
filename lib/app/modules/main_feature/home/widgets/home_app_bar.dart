import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../app_constants/app_assets.dart';
import '../../../../core/helpers/data_helper.dart';
import '../../../../core/localization/language_key.dart';
import '../../../../core/widgets/go_login.dart';
import '../../shared/constant/home_routes.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}
