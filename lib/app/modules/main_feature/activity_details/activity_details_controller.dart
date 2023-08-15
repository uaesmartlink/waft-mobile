import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/models/review_model.dart';
import 'package:sport/app/core/models/service_model.dart';
import 'package:sport/app/core/models/user_model.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/core/services/data_list_mixin.dart';
import 'package:sport/app/core/services/request_mixin.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';
import 'package:sport/app/modules/auth/auth_module.dart';

import '../../../core/services/getx_state_controller.dart';

class ActivityDetailsController extends GetxStateController
    with GetSingleTickerProviderStateMixin, DataList<Review> {
  final ActivitiesRepository activitiesRepository;
  final ConstantsRepository constantsRepository;
  TabController? tabController;
  bool checkBooking = false;
  ActivityDetailsController({
    required this.activitiesRepository,
    required this.constantsRepository,
  });
  StreamController<Widget> overlayController =
      StreamController<Widget>.broadcast();
  @override
  void onInit() {
    getStadia();
    super.onInit();
  }

  int? activityId;
  @override
  void onClose() {
    overlayController.close();
    super.onClose();
  }

  int getTabLength() {
    int tabLength = 2;
    if (activity.services.isNotEmpty) {
      tabLength++;
    }
    if (activity.images.isNotEmpty) {
      tabLength++;
    }

    return tabLength;
  }

  int tabBarIndex = 0;
  void changeSelectedTabBarIndex(int tabBarIndex) {
    this.tabBarIndex = tabBarIndex;
    if (tabBarIndex == tabController!.length - 1 && dataList.isEmpty) {
      getReviews();
    }
    update(["getStadia"]);
  }

  late Activity activity;
  Future<void> getStadia(
      [RequestType requestType = RequestType.getData]) async {
    await requestMethod(
      ids: ["getStadia"],
      stateLessIds: ["PackagesWidget", "ServicesWidget"],
      requestType: requestType,
      showErrorToast: false,
      function: () async {
        if (activityId == null &&
            (Get.parameters["activityId"] == null ||
                int.tryParse(Get.parameters["activityId"]!) == null)) {
          Get.offAllNamed(AuthModule.authInitialRoute);
          return;
        } else {
          activityId ??= int.parse(Get.parameters["activityId"]!);
        }
        if (DataHelper.logedIn &&
            DataHelper.user?.browsingType != AccountType.manager) {
          checkBooking =
              await activitiesRepository.checkBooking(stadiumId: activityId!);
        }
        activity = await activitiesRepository.getStadia(id: activityId!);
        saved = activity.isFavorite;
        tabController ??= TabController(
            length: DataHelper.user?.browsingType == AccountType.manager
                ? 6
                : getTabLength(),
            vsync: this);
        return null;
      },
    );
  }

  bool saved = false;
  Future<void> toggelSaved() async {
    saved = !saved;
    update(["isFavorite"]);
    bool result;
    if (!saved) {
      result = await removeFromFavorites(favoriteId: activity.favoriteId);
    } else {
      result = await addToFavorites(stadiumId: activity.id);
    }
    if (!result) {
      saved = !saved;
      update(["isFavorite"]);
    }
  }

  Future<bool> addToFavorites({required int stadiumId}) async {
    try {
      await activitiesRepository.addToFavorites(stadiumId: stadiumId);
      await getStadia(RequestType.refresh);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeFromFavorites({required int? favoriteId}) async {
    try {
      if (favoriteId != null) {
        await activitiesRepository.removeFromFavorites(favoriteId: favoriteId);
        await getStadia(RequestType.refresh);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> getReviews(
      [RequestType requestType = RequestType.getData]) async {
    await handelDataList(
      ids: ["getReviews"],
      requestType: requestType,
      function: () async {
        return await activitiesRepository.getReviews(
          page: page,
          stadiumId: activity.id,
          perPage: dataList.isEmpty ? 7 : 30,
        );
      },
    );
  }

  Future<void> addReview({
    required int rating,
    required String comment,
  }) async {
    await requestMethod(
      ids: ["addReview"],
      stateLessIds: ["getReviews"],
      requestType: RequestType.getData,
      loadedMessage: LanguageKey.ratingAddedSuccessfully.tr,
      function: () async {
        Review review = await activitiesRepository.addReview(
          stadiumId: activity.id,
          rating: rating,
          comment: comment,
        );

        Get.back();
        dataList.insert(0, review);
        return null;
      },
    );
  }

  List<ServiceModel> services = [];

  Future<void> getServices(
      [RequestType requestType = RequestType.getData]) async {
    await requestMethod(
      ids: ["getServices"],
      requestType: requestType,
      function: () async {
        services = await constantsRepository.getServices();
        return null;
      },
    );
  }

  Future<void> addStadiumServices({
    required int serviceId,
  }) async {
    await requestMethod(
      ids: ["addServiceDialog"],
      requestType: RequestType.getData,
      function: () async {
        await constantsRepository.addStadiumServices(
          stadiumId: activity.id,
          serviceId: serviceId,
        );
        Get.back();
        await getStadia(RequestType.refresh);
        return null;
      },
    );
  }

  Future<void> deleteStadiumServices({
    required int serviceId,
  }) async {
    await requestMethod(
      ids: ["deleteServiceDialog"],
      requestType: RequestType.getData,
      function: () async {
        await constantsRepository.deleteStadiumServices(
          serviceId: serviceId,
        );
        Get.back();
        await getStadia(RequestType.refresh);
        return null;
      },
    );
  }

  Future<void> addStadiumPackage({
    required int price,
    required int slot,
    required String nameEn,
    required String nameAr,
    required String type,
    required String slotType,
  }) async {
    await requestMethod(
      ids: ["addPackageDialog"],
      requestType: RequestType.getData,
      function: () async {
        await activitiesRepository.addStadiumPackage(
          stadiumId: activity.id,
          userId: DataHelper.user!.id,
          nameAr: nameAr,
          nameEn: nameEn,
          price: price,
          slot: slot,
          type: type,
          slotType: slotType,
        );
        Get.back();
        await getStadia(RequestType.refresh);
        return null;
      },
    );
  }

  Future<void> updateStadiumPackage({
    required int packageId,
    required int price,
    required int slot,
    required String nameEn,
    required String nameAr,
    required String slotType,
    required String type,
  }) async {
    await requestMethod(
      ids: ["addPackageDialog"],
      requestType: RequestType.getData,
      function: () async {
        await activitiesRepository.updateStadiumPackage(
          packageId: packageId,
          nameAr: nameAr,
          nameEn: nameEn,
          price: price,
          slot: slot,
          type: type,
          slotType: slotType,
        );
        Get.back();
        await getStadia(RequestType.refresh);
        return null;
      },
    );
  }

  Future<void> deleteStadiumPackage({
    required int packageId,
  }) async {
    await requestMethod(
      ids: ["deletePackageDialog"],
      requestType: RequestType.getData,
      function: () async {
        await activitiesRepository.deleteStadiumPackage(
          packageId: packageId,
        );
        Get.back();
        await getStadia(RequestType.refresh);
        return null;
      },
    );
  }

  Future<void> pickImageGallery() async {
    try {
      final pick = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pick != null) {
        int sizeInBytes = File(pick.path).lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (sizeInMb > 2) {
          AppMessenger.message(LanguageKey.imageSize.tr);
          return;
        }
        await addImageToGallery(image: File(pick.path));
      }
    } catch (_) {}
  }

  Future<void> addImageToGallery({required File image}) async {
    await requestMethod(
      ids: ["addImageToGallery"],
      requestType: RequestType.getData,
      showLoading: true,
      function: () async {
        await activitiesRepository.addImageToGallery(
          stadiumId: activity.id,
          image: image,
        );
        await getStadia(RequestType.refresh);
        return null;
      },
    );
  }

  Future<void> deleteImage({required int imageId}) async {
    await requestMethod(
      ids: ["deleteImage"],
      requestType: RequestType.getData,
      showLoading: true,
      function: () async {
        await activitiesRepository.deleteImage(
          stadiumId: activity.id,
          imageId: imageId,
        );
        await getStadia(RequestType.refresh);
        return null;
      },
    );
  }

  Future<void> addWorkTime({
    required String day,
    required String startTime,
    required String endTime,
  }) async {
    await requestMethod(
      ids: ["addWorkTimeDialog"],
      requestType: RequestType.getData,
      function: () async {
        await activitiesRepository.addWorkTime(
          stadiumId: activity.id,
          day: day,
          endTime: endTime,
          startTime: startTime,
        );
        Get.back();
        await getStadia(RequestType.refresh);
        return null;
      },
    );
  }

  Future<void> updateWorkTime({
    required int workTimeId,
    required String day,
    required String startTime,
    required String endTime,
  }) async {
    await requestMethod(
      ids: ["addWorkTimeDialog"],
      requestType: RequestType.getData,
      function: () async {
        await activitiesRepository.updateWorkTime(
          stadiumId: activity.id,
          workTimeId: workTimeId,
          day: day,
          endTime: endTime,
          startTime: startTime,
        );
        Get.back();
        await getStadia(RequestType.refresh);
        return null;
      },
    );
  }

  Future<void> deleteWorkTime({
    required int workTimeId,
  }) async {
    await requestMethod(
      ids: ["deleteWorkTimeDialog"],
      requestType: RequestType.getData,
      function: () async {
        await activitiesRepository.deleteWorkTime(
          workTimeId: workTimeId,
        );
        Get.back();
        await getStadia(RequestType.refresh);
        return null;
      },
    );
  }
}
