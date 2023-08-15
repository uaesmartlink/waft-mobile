import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/localization/locales/ar.dart';
import 'package:sport/app/core/localization/locales/en.dart';
import 'package:sport/app/core/services/user_config.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'ar': ar,
      };
  static Locale get currentLanguage => Get.locale ?? const Locale("en");
  static String get languageCode => currentLanguage.languageCode;
  static void changeSelectedLanguage(String languageCode) {
    UserConfig.setLanguageCode(languageCode);
    Get.updateLocale(Locale(languageCode));
  }

  static Future<String> get currentLanguageCode async {
    return await UserConfig.getLanguageCode() ?? languageCode;
  }

  static bool get isArabic {
    return languageCode == "ar";
  }
}
