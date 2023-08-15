import 'package:sport/app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    required this.width,
    required this.height,
    required this.shapeBorder,
    this.baseColor = AppColors.primary,
    this.highlightColor = AppColors.secondry,
    Key? key,
  }) : super(key: key);

  const ShimmerWidget.circular(
      {required this.height,
      required this.width,
      this.baseColor = AppColors.backgroundTextFilled,
      this.highlightColor = AppColors.secondry,
      this.shapeBorder = const CircleBorder(),
      Key? key})
      : super(key: key);

  const ShimmerWidget.rectangle(
      {required this.height,
      this.baseColor = AppColors.backgroundTextFilled,
      this.highlightColor = AppColors.secondry,
      required this.width,
      Key? key})
      : shapeBorder = const RoundedRectangleBorder(),
        super(key: key);

  final double height;
  final ShapeBorder shapeBorder;
  final double width;
  final Color baseColor;
  final Color highlightColor;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: AppColors.backgroundTextFilled,
            shape: shapeBorder,
          ),
        ));
  }
}
