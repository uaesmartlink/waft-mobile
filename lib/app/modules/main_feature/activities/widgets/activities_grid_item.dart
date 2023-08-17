import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app_constants/app_dimensions.dart';
import '../../../../core/models/activity_type_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/cached_network_image.dart';
import '../../search_activities/search_activities_controller.dart';
import '../../shared/constant/home_routes.dart';

class ActivityGridItem extends StatelessWidget {
  const ActivityGridItem({super.key, required this.activityType});
  final ActivityType activityType;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          HomeRoutes.searchActivitiesRoute,
          arguments: {
            "searchMode": SearchMode.category,
            "selectedActivityType": activityType,
          },
        );
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: double.infinity,
              child:
              CachedImage(imageUrl: activityType.image),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [
                  Colors.black54,
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.generalPadding),
            child: Text(
              activityType.name,
              style: const TextStyle(
                color: AppColors.background,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
