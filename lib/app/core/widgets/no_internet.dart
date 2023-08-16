import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/theme/colors.dart';

import '../../../app_constants/app_dimensions.dart';
import '../services/size_configration.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({
    required this.onRetryFunction,
    Key? key,
  }) : super(key: key);

  final Function? onRetryFunction;

  @override
  Widget build(BuildContext context) {
    return ScreenSizer(builder: (customSize) {
      return SizedBox(
        width: customSize.screenWidth,
        height: customSize.screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppDimensions.generalPadding),
            Text(
              LanguageKey.noInternet.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: AppColors.fontGray,
              ),
            ),
            const SizedBox(height: AppDimensions.generalPadding),
            onRetryFunction == null
                ? const SizedBox()
                : OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.secondry,
                      ),
                    ),
                    onPressed: () => onRetryFunction!(),
                    icon: const Icon(
                      Icons.refresh,
                      color: AppColors.secondry,
                    ),
                    label: Text(
                      LanguageKey.tryAgain.tr,
                      style: const TextStyle(
                        color: AppColors.secondry,
                      ),
                    ),
                  ),
          ],
        ),
      );
    });
  }
}
