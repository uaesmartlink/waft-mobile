import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/colors.dart';

class CachedImage extends StatelessWidget {
  const CachedImage(
      {required this.imageUrl,
      this.borderRadius,
      this.fit = BoxFit.cover,
      Key? key})
      : super(key: key);

  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.codeInput,
        highlightColor: AppColors.backgroundTextFilled,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.backgroundTextFilled,
              borderRadius: borderRadius ?? BorderRadius.circular(20)),
          height: MediaQuery.of(context).size.width * (9 / 16),
        ),
      ),
      errorWidget: (_, __, ___) {
        return const SizedBox();
      },
      fit: fit,
    );
  }
}
