import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/modules/main_feature/shared/constant/home_routes.dart';

class ManagerActivityItem extends StatefulWidget {
  const ManagerActivityItem({
    super.key,
    required this.activity,
  });
  final Activity activity;

  @override
  State<ManagerActivityItem> createState() => _ManagerActivityItemState();
}

class _ManagerActivityItemState extends State<ManagerActivityItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          HomeRoutes.activityDetailsRoute,
          parameters: {"activityId": widget.activity.id.toString()},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 25,
              offset: const Offset(1, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: ScreenSizer(
          constWidth: 100,
          builder: (CustomSize customSize) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: double.infinity,
                      imageUrl: widget.activity.image,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: AppColors.background,
                        highlightColor: AppColors.backgroundTextFilled,
                        child: const SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      errorWidget: (_, __, ___) {
                        return const Placeholder();
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: customSize.screenWidth,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.activity.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.activity.address,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.fontGray,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.activity.rating != null)
                          Row(
                            children: [
                              Icon(
                                widget.activity.rating! < 2
                                    ? Icons.star_border_rounded
                                    : widget.activity.rating == 5
                                        ? Icons.star_rounded
                                        : Icons.star_half_rounded,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  widget.activity.rating!.toStringAsFixed(1),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        else
                          const SizedBox(
                            height: 10,
                          )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                  child: Icon(
                    Icons.circle,
                    color: widget.activity.status == "Pending"
                        ? AppColors.secondry
                        : widget.activity.status == "Approved"
                            ? AppColors.green
                            : AppColors.red,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
