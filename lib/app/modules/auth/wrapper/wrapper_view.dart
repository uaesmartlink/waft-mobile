import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/constants_model.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/utils/intl.dart';

import '../../../../app_constants/app_assets.dart';
import '../../../core/services/size_configration.dart';
import '../../../core/widgets/widget_state.dart';
import 'wrapper_controller.dart';

class WrapperView extends GetView<WrapperController> {
  const WrapperView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenSizer(builder: (CustomSize customSize) {
        return StateBuilder<WrapperController>(
            id: "WrapperView",
            disableState: true,
            builder: (widgetState, controller) {
              return SizedBox(
                width: customSize.screenWidth,
                child: Column(
                  children: [
                    const Spacer(),
                    const SizedBox(height: 45),
                    const SizedBox(height: 20),
                    Image.asset(
                      AppAssets.logo,
                      width: customSize.screenWidth / 2,
                      height: customSize.screenWidth / 2,
                    ),
                    const SizedBox(height: 20),
                    if (widgetState == WidgetState.error)
                      SizedBox(
                        height: 45,
                        child: ElevatedButton(
                            onPressed: () {
                              controller.initWrapper();
                            },
                            child: Text(LanguageKey.tryAgain.tr)),
                      )
                    else
                      const SizedBox(height: 45),
                    const Spacer(),
                  ],
                ),
              );
            });
      }),
    );
  }
}

void appUpdateBottomSheet({
  required AppVersion appVersion,
  required Function() onUpdate,
  required Function() onIgnore,
}) {
  Get.bottomSheet(
    WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: ScreenSizer(builder: (customSize) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
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
            children: [
              const Text(
                'WAFT',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                LanguageKey.newVersionAvailable.tr,
                textAlign: TextAlign.start,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                '${LanguageKey.currentVersion.tr} ${DataHelper.packageInfo.version}     ${LanguageKey.newVersion.tr} ${appVersion.versionName}',
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              const SizedBox(height: 10),
              if (appVersion.aboutThisVersion != "")
                Row(
                  children: [
                    Text(
                      LanguageKey.newInThisVersion.tr,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              if (appVersion.aboutThisVersion != "") const SizedBox(height: 5),
              if (appVersion.aboutThisVersion != "")
                SizedBox(
                  child: Directionality(
                    textDirection: getTextDirection(
                      appVersion.aboutThisVersion,
                    ),
                    child: Markdown(
                      selectable: true,
                      shrinkWrap: true,
                      data: appVersion.aboutThisVersion,
                    ),
                  ),
                ),
              SizedBox(
                height: 40,
                width: customSize.screenWidth,
                child: appVersion.forceUpdate
                    ? SizedBox(
                        width: customSize.setWidth(300),
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            onUpdate();
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.primary),
                          ),
                          child: Text(
                            LanguageKey.update.tr,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: customSize.setWidth(200),
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                onUpdate();
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppColors.primary),
                              ),
                              child: Text(
                                LanguageKey.update.tr,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              onIgnore();
                            },
                            child: Text(LanguageKey.ignore.tr),
                          )
                        ],
                      ),
              )
            ],
          ),
        );
      }),
    ),
    isDismissible: false,
    enableDrag: false,
    enterBottomSheetDuration: const Duration(milliseconds: 200),
    isScrollControlled: true,
  );
}
