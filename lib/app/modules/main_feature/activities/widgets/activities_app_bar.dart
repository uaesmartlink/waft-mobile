import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app_constants/app_assets.dart';
import '../../../../core/localization/language_key.dart';

class ActivitiesAppBar extends StatelessWidget {
  const ActivitiesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      leading: Padding(
        padding: const EdgeInsets.all(5),
        child: Image.asset(
          AppAssets.logo,
        ),
      ),
      title: Text(
        LanguageKey.activities.tr,
      ),
    );
  }
}
