import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/models/user_model.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/cached_network_image.dart';
import 'package:sport/app/core/widgets/no_resulte.dart';
import 'package:sport/app/modules/main_feature/activity_details/activity_details_controller.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

import '../../../../../app_constants/app_dimensions.dart';

class GalleryWidget extends GetView<ActivityDetailsController> {
  const GalleryWidget({required this.images, super.key});
  final List<ActivityImage> images;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const NoResults();
    } else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(AppDimensions.generalPadding, AppDimensions.generalPadding, AppDimensions.generalPadding, 100),
        itemBuilder: (context, index) {
          final ActivityImage activityImage = images[index];
          return InkWell(
            onTap: () {
              SwipeImageGallery(
                context: context,
                itemCount: images.length,
                hideStatusBar: false,
                hideOverlayOnTap: false,
                initialIndex: index,
                onSwipe: (index) {
                  controller.overlayController.add(OverlayImage(
                    title: '${index + 1}/${images.length}',
                  ));
                },
                overlayController: controller.overlayController,
                initialOverlay: OverlayImage(
                  title: '${index + 1}/${images.length}',
                ),
                itemBuilder: (context, index) {
                  return PhotoView(
                    minScale: PhotoViewComputedScale.contained,
                    imageProvider: CachedNetworkImageProvider(
                      images[index].imagePath,
                    ),
                  );
                },
              ).show();
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    height: double.infinity,
                    child: Hero(
                        tag: "${activityImage.imagePath}DetailScreen",
                        child: CachedImage(imageUrl: activityImage.imagePath)),
                  ),
                ),
                if (DataHelper.user?.browsingType == AccountType.manager)
                  IconButton(
                    onPressed: () {
                      controller.deleteImage(imageId: activityImage.id);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: AppColors.red,
                    ),
                  ),
              ],
            ),
          );
        },
        itemCount: images.length,
      );
    }
  }
}

class DetailScreen extends StatelessWidget {
  final String imageUrl;
  const DetailScreen({
    required this.imageUrl,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Hero(
              tag: "${imageUrl}DetailScreen",
              child: PhotoView(
                minScale: PhotoViewComputedScale.contained,
                imageProvider: CachedNetworkImageProvider(imageUrl),
              )),
        ),
      ),
    );
  }
}

class OverlayImage extends StatelessWidget {
  const OverlayImage({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.black.withAlpha(50),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 18.0,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.white,
            tooltip: 'Close',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
