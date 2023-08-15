import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/modules/auth/shared/constant/auth_routes.dart';

void loginBottomSheet({required String description}) {
  Get.bottomSheet(
    ScreenSizer(
        constWidth: 40,
        builder: (customSize) {
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  LanguageKey.signIn.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.fontGray,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 50,
                      width: customSize.screenWidth / 2 - 10,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.splash,
                          elevation: 0,
                        ),
                        child: Text(
                          LanguageKey.back.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: customSize.screenWidth / 2 - 10,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          Get.toNamed(AuthRoutes.loginRoute);
                        },
                        child: Text(
                          LanguageKey.signIn.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
    isDismissible: true,
    enableDrag: true,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
    isScrollControlled: true,
  );
}
