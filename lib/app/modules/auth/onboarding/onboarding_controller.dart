import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/models/constants_model.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/modules/main_feature/home_module.dart';

import '../../../core/services/getx_state_controller.dart';

class OnBoardingController extends GetxStateController {
  @override
  void onInit() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black54,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    pages = DataHelper.constants!.onboarding;
    super.onInit();
  }

  PageController pageController = PageController();
  int pageIndex = 0;
  List<Onboarding> pages = [];
  void onPageChanged(int pageIndex) {
    this.pageIndex = pageIndex;
    update(["OnBoardingPageView"]);
  }

  void changePage() {
    if (pageIndex == (pages.length - 1)) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
      Get.offAndToNamed(HomeModule.homeInitialRoute);
    } else {
      pageIndex++;
      pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
      onPageChanged(pageIndex);
    }
  }
}
