import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/localization/language_key.dart';
import '../../search_activities/search_activities_controller.dart';
import '../../shared/constant/home_routes.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: () {
        Get.toNamed(
          HomeRoutes.searchActivitiesRoute,
          arguments: {"searchMode": SearchMode.search},
        );
      },
      decoration: InputDecoration(
        hintText: LanguageKey.search.tr,
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}
