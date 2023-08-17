import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/localization/translation.dart';
import 'package:sport/app/core/models/user_model.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';
import 'package:sport/app/core/widgets/go_login.dart';
import 'package:sport/app/core/widgets/no_internet.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/home/widgets/home_app_bar.dart';
import 'package:sport/app/modules/main_feature/home/widgets/home_banner.dart';
import 'package:sport/app/modules/main_feature/home/widgets/home_activities_list_view.dart';
import 'package:sport/app/modules/main_feature/home/widgets/nearby_location_tab_bar.dart';
import 'package:sport/app/modules/main_feature/home/widgets/search_text_field.dart';
import 'package:sport/app/modules/main_feature/home/widgets/section.dart';
import 'package:sport/app/modules/main_feature/home/widgets/section_header.dart';
import 'package:sport/app/modules/main_feature/profile/profile_view.dart';
import 'package:sport/app/modules/main_feature/search_activities/search_activities_controller.dart';
import 'package:sport/app/modules/main_feature/shared/constant/home_routes.dart';
import 'package:sport/app_constants/app_dimensions.dart';

import '../../../../app_constants/app_assets.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const PreferredSize(
        preferredSize:  Size(double.infinity, 100),
        child: HomeAppBar(),
      ),
      body: ScreenSizer(
        builder: (customSize) {
          return Column(
            children: [
              GetBuilder<HomeController>(
                id: "hi",
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.generalPadding),
                    child: SizedBox(
                      height: 125,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${LanguageKey.hi.tr}, ${DataHelper.user?.name.substring(0, DataHelper.user!.name.contains(" ") ? DataHelper.user!.name.indexOf(" ") : null) ?? ""} 👋",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: Translation.isArabic ? 5 : AppDimensions.generalPadding),
                          const SearchTextField(),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: customSize.screenHeight - 125,
                child: RefreshIndicator(
                  onRefresh: controller.refreshHomeData,
                  child:const SingleChildScrollView(
                    padding:  EdgeInsets.only(bottom: AppDimensions.generalPadding),
                    physics:  BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                      children: [
                        SizedBox(height: AppDimensions.generalPadding),
                        HomeBanner(),
                        NearbyLocationTabBar(),
                        SizedBox(height: AppDimensions.generalPadding),
                        HomeActivitiesListView(),
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

}
