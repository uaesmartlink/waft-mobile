import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/worktime_model.dart';
import 'package:sport/app/core/theme/colors.dart';

import '../../../../../app_constants/app_dimensions.dart';

class AboutUsWidget extends StatelessWidget {
  const AboutUsWidget({
    super.key,
    required this.workTimes,
    required this.description,
  });
  final List<WorkTime> workTimes;
  final String description;
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppDimensions.generalPadding, AppDimensions.generalPadding, AppDimensions.generalPadding, 100),
      children: [
        Text(
          LanguageKey.workingHours.tr,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        for (int i = 0; i < workTimes.length; i++)
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  workTimes[i].day.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.fontGray,
                  ),
                ),
              ),
              Text(
                workTimes[i]
                    .startTime
                    .substring(0, workTimes[i].startTime.length - 3),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const Text(
                " - ",
              ),
              Text(
                workTimes[i]
                    .endTime
                    .substring(0, workTimes[i].endTime.length - 3),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        const SizedBox(height: AppDimensions.generalPadding),
        Text(
          LanguageKey.aboutUs.tr,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
        ),
      ],
    );
  }
}
