import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/modules/main_feature/language/language_controller.dart';

import '../../../../app_constants/app_dimensions.dart';

class LanguageView extends GetView<LanguageController> {
  const LanguageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: AppBar(
          toolbarHeight: 100,
          title: Text(
            LanguageKey.language.tr,
          ),
        ),
      ),
      body: GetBuilder<LanguageController>(
          id: "changeSelectedLanguage",
          builder: (context) {
            return ListView(
              padding: const EdgeInsets.all(AppDimensions.generalPadding),
              children: [
                InkWell(
                  onTap: () {
                    controller.changeSelectedLanguage('en');
                  },
                  child: Row(
                    children: [
                      Text(
                        LanguageKey.englishUS.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Radio(
                        value: 'en',
                        groupValue: controller.selectedLanguage,
                        onChanged: (value) {
                          controller.changeSelectedLanguage(value!);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    controller.changeSelectedLanguage('ar');
                  },
                  child: Row(
                    children: [
                      Text(
                        LanguageKey.arabic.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Radio(
                        value: 'ar',
                        groupValue: controller.selectedLanguage,
                        onChanged: (value) {
                          controller.changeSelectedLanguage(value!);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
