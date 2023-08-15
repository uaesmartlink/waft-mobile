// ignore_for_file: unnecessary_cast

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/widget_state.dart';

Widget circleAvatar({
  required double radius,
  required ImageProvider? image,
  required WidgetState widgetState,
  IconData? icon,
}) =>
    Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.codeInput,
          backgroundImage: image,
          child: image == null
              ? Center(
                  child: Icon(
                    icon ?? Icons.person,
                    color: AppColors.fontGray,
                    size: radius,
                  ),
                )
              : null,
        ),
        CircleAvatar(
          backgroundColor: AppColors.codeInput,
          child: Icon(
            image == null ? Icons.add_a_photo : Icons.edit,
            color: AppColors.primary,
          ),
        )
      ],
    );
Widget circleAvatarNetwork({
  required double radius,
  File? image,
  String? imageUrl,
  required WidgetState widgetState,
}) {
  ImageProvider backgroundImage = image != null
      ? FileImage(image)
      : (CachedNetworkImageProvider(imageUrl!) as ImageProvider);
  return Stack(
    alignment: AlignmentDirectional.bottomEnd,
    children: [
      CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.codeInput,
        backgroundImage: backgroundImage,
        child: image == null && imageUrl == null
            ? Center(
                child: Icon(
                  Icons.person,
                  color: AppColors.fontGray,
                  size: radius,
                ),
              )
            : null,
      ),
      CircleAvatar(
        backgroundColor: AppColors.codeInput,
        child: Icon(
          image == null && imageUrl == null ? Icons.add_a_photo : Icons.edit,
          color: AppColors.primary,
        ),
      )
    ],
  );
}
