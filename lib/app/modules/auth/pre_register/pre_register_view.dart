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
import 'pre_register_controller.dart';

class PreRegisterView extends GetView<PreRegisterController> {
  const PreRegisterView({Key? key}) : super(key: key);

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
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ),
          ),
        );
      }),
    );
  }
}
