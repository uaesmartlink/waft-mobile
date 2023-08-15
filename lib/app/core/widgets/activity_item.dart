import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/go_login.dart';

class ActivityItem extends StatefulWidget {
  const ActivityItem({
    super.key,
    this.onSave,
    this.onRemove,
    required this.title,
    required this.address,
    required this.imageUrl,
    required this.saved,
    required this.rating,
  });
  final Future<bool> Function()? onSave;
  final Future<bool> Function()? onRemove;
  final String title;
  final String address;
  final String imageUrl;
  final double? rating;
  final bool saved;

  @override
  State<ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  bool saved = false;
  Future<void> toggelSaved() async {
    if (widget.onRemove != null && widget.onSave != null) {
      saved = !saved;
      setState(() {});
      bool result;
      if (!saved) {
        result = await widget.onRemove!();
      } else {
        result = await widget.onSave!();
      }
      if (!result) {
        saved = !saved;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    saved = widget.saved;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        constWidth: 105,
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
                    imageUrl: widget.imageUrl,
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
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.address,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.fontGray,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.rating != null)
                        Row(
                          children: [
                            Icon(
                              widget.rating! < 2
                                  ? Icons.star_border_rounded
                                  : widget.rating == 5
                                      ? Icons.star_rounded
                                      : Icons.star_half_rounded,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                widget.rating!.toStringAsFixed(1),
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
              saved
                  ? SizedBox(
                      width: 25,
                      height: 25,
                      child: InkWell(
                        onTap: () {
                          if (DataHelper.logedIn) {
                            toggelSaved();
                          } else {
                            loginBottomSheet(
                                description:
                                    LanguageKey.loginToAddFavorites.tr);
                          }
                        },
                        child: SvgPicture.asset(
                          "assets/images/Saved_solid.svg",
                          width: 25,
                          height: 25,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 25,
                      height: 25,
                      child: InkWell(
                        onTap: () {
                          if (DataHelper.logedIn) {
                            toggelSaved();
                          } else {
                            loginBottomSheet(
                                description:
                                    LanguageKey.loginToAddFavorites.tr);
                          }
                        },
                        child: SvgPicture.asset(
                          "assets/images/Saved_border.svg",
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
