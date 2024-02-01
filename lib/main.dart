import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
// import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/localization/translation.dart';
import 'package:sport/app/core/services/notifications/firebase_cloud_messaging.dart';
import 'package:sport/app/core/services/user_config.dart';
import 'package:sport/app/modules/auth/auth_module.dart';

import 'app/core/constants/globals.dart';
import 'app/core/helpers/data_helper.dart';
import 'app/core/theme/colors.dart';
import 'app/core/theme/theme.dart';
import 'app/core/utils/logger.dart';
import 'app/core/widgets/app_messenger.dart';
import 'app_initial_binding.dart';
import 'app_pages.dart';

part 'app_initialize.dart';

void main() async {
  await _preInitializations();
  runApp(const MainWidget());
}

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: snackbarKey,
      initialRoute: AuthModule.authInitialRoute,
      getPages: AppPages.appRoutes,
      translations: Translation(),
      fallbackLocale: const Locale("en"),
      initialBinding: AppInitialBindings(),
      locale: Locale(languageCode),
      debugShowCheckedModeBanner: false,
      enableLog: appMode != AppMode.release,
      theme: CustomTheme.lightTheme(context),
      builder: (context, child) {
        final botToastBuilder = BotToastInit();
        child = botToastBuilder(context, child);
        child = MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child,
        );
        return child;
      },
      navigatorObservers: [BotToastNavigatorObserver()],
    );
  }
}
