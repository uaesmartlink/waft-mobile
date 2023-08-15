import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/constants_model.dart';
import 'package:sport/app/core/theme/colors.dart';

import 'onboarding_controller.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
        id: "OnBoardingPageView",
        builder: (controller) {
          return Scaffold(
            body: PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              children:
                  controller.pages.map((page) => _pageBuilder(page)).toList(),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SmoothPageIndicator(
                  count: controller.pages.length,
                  controller: controller.pageController,
                  axisDirection: Axis.horizontal,
                  effect: const ExpandingDotsEffect(
                    spacing: 8.0,
                    radius: 15,
                    dotWidth: 15,
                    dotHeight: 8,
                    paintStyle: PaintingStyle.fill,
                    dotColor: AppColors.background,
                    activeDotColor: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.changePage,
                    child: Text(
                      controller.pageIndex == (controller.pages.length - 1)
                          ? LanguageKey.getStarted.tr
                          : LanguageKey.next.tr,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        });
  }

  Widget _pageBuilder(Onboarding page) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CachedNetworkImage(
            imageUrl: page.imageUrl,
            placeholder: (_, __) => Shimmer.fromColors(
              baseColor: AppColors.background,
              highlightColor: AppColors.backgroundTextFilled,
              child: const SizedBox(
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            errorWidget: (_, __, ___) {
              return const SizedBox();
            },
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 160),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                page.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.secondry,
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                page.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.background,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OnBoardingPage {
  final String title;
  final String description;
  final String imageUrl;

  OnBoardingPage(this.title, this.description, this.imageUrl);
}
