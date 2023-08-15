// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/modules/auth/auth_module.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/widget_state.dart';
import 'blocked_controller.dart';

class BlockedView extends GetView<BlockedController> {
  const BlockedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenSizer(builder: (CustomSize customSize) {
        return RefreshIndicator(
          onRefresh: () async {
            Get.offAllNamed(AuthModule.authInitialRoute);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: customSize.screenHeight,
              width: customSize.screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.block,
                    size: 100,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    LanguageKey.blockedAccount.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        launchUrl(Uri.parse(
                            'tel:${DataHelper.constants!.supportPhoneNumber}'));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.phone, color: AppColors.background),
                          const SizedBox(width: 10),
                          Text(
                            LanguageKey.contactUs.tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.background),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: controller.logout,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.logout, color: AppColors.background),
                          const SizedBox(width: 10),
                          Text(
                            LanguageKey.logout.tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.background),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
