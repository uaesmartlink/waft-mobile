import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/models/activity_type_model.dart';
import 'package:sport/app/core/models/city_model.dart';
import 'package:sport/app/core/models/region_model.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';
import 'package:sport/app/core/widgets/input_fields.dart' hide EmailValidator;

import '../../../core/services/getx_state_controller.dart';
import '../../../core/services/request_mixin.dart';

class AddActivityController extends GetxStateController {
  final ActivitiesRepository activitiesRepository;
  final ConstantsRepository constantsRepository;
  final PageController pageController = PageController();
  int pageIndex = 0;
  Activity? activity;
  void changePage(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    this.pageIndex = pageIndex;
    update(["addActivity"]);
  }

  AddActivityController({
    required this.activitiesRepository,
    required this.constantsRepository,
  });

  Future<void> addActivity({
    required String nameEn,
    required String nameAr,
    required int regionId,
    required int activityId,
    required String mapUrl,
    required String descriptionEn,
    required String descriptionAr,
    required String addressAr,
    required String addressEn,
    required String phone,
    required String email,
    required String website,
  }) async {
    await requestMethod(
      ids: ["addActivity"],
      requestType: RequestType.getData,
      function: () async {
        await activitiesRepository.addActivity(
          nameEn: nameEn,
          nameAr: nameAr,
          regionId: regionId,
          activityId: activityId,
          mapUrl: mapUrl,
          descriptionEn: descriptionEn,
          descriptionAr: descriptionAr,
          addressAr: addressAr,
          addressEn: addressEn,
          phone: phone,
          email: email,
          website: website,
          image: activityImage!,
        );
        Get.back();
        return null;
      },
    );
  }

  Future<void> updateActivity({
    required String nameEn,
    required String nameAr,
    required int regionId,
    required int activityId,
    required String mapUrl,
    required String descriptionEn,
    required String descriptionAr,
    required String addressAr,
    required String addressEn,
    required String phone,
    required String email,
    required String website,
  }) async {
    await requestMethod(
      ids: ["addActivity"],
      requestType: RequestType.getData,
      function: () async {
        await activitiesRepository.updateActivity(
          stadiaId: activity!.id,
          nameEn: nameEn,
          nameAr: nameAr,
          regionId: regionId,
          activityId: activityId,
          mapUrl: mapUrl,
          descriptionEn: descriptionEn,
          descriptionAr: descriptionAr,
          addressAr: addressAr,
          addressEn: addressEn,
          phone: phone,
          email: email,
          website: website,
          image: activityImage,
        );
        Get.back();
        return null;
      },
    );
  }

  List<City> cities = [];

  Future<void> getCities(
      [RequestType requestType = RequestType.getData]) async {
    await requestMethod(
      ids: ["getCities"],
      requestType: requestType,
      showErrorToast: false,
      function: () async {
        cities = await constantsRepository.getCities();

        return null;
      },
    );
  }

  List<Region> regions = [];
  Future<void> getRegions({required int cityId}) async {
    await requestMethod(
      ids: ["getRegions"],
      requestType: RequestType.getData,
      showErrorToast: false,
      function: () async {
        regions = await constantsRepository.getRegions(cityId: cityId);
        firstAddActivityForm.findControl("region_id")?.updateValue(null);
        return null;
      },
    );
  }

  List<ActivityType> activityTypes = [];

  Future<void> getActivityTypes(
      [RequestType requestType = RequestType.getData]) async {
    await requestMethod(
      ids: ["getActivityTypes"],
      requestType: requestType,
      showErrorToast: false,
      function: () async {
        activityTypes = await constantsRepository.getActivityTypes();

        return null;
      },
    );
  }

  File? activityImage;
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
        activityImage = File(pick.path);
      }
      update(["profile"]);
    } catch (_) {}
  }

  @override
  void onInit() {
    activity = Get.arguments?["activity"];
    getCities();
    getActivityTypes();
    thirdAddActivityForm = FormGroup({
      "name_en": FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(100),
        ],
        value: activity?.nameEn,
      ),
      "address_en": FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(200),
        ],
        value: activity?.addressEn,
      ),
      "description_en": FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(5000),
          Validators.minLength(10),
        ],
        value: activity?.descriptionEn,
      ),
    });
    firstAddActivityForm = FormGroup({
      "region_id": FormControl<int>(
        validators: [
          Validators.required,
        ],
        value: activity?.regionId,
      ),
      "city_id": FormControl<int>(
        validators: [
          Validators.required,
        ],
      ),
      "activity_id": FormControl<int>(
        validators: [
          Validators.required,
        ],
        value: activity?.activityId,
      ),
      "website": FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(100),
          const URLValidator(),
        ],
        value: activity?.website,
      ),
      "email": FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(40),
          const EmailValidator(),
        ],
        value: activity?.email,
      ),
      "phone": FormControl<String>(
        validators: [
          Validators.required,
          const PhoneValidator(),
        ],
        value: activity?.phone.replaceAll("+971", "0"),
      ),
      "map_url": FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(100),
          const URLValidator(),
        ],
        value: activity?.mapUrl,
      ),
    });
    secondAddActivityForm = FormGroup({
      "name_ar": FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(100),
        ],
        value: activity?.nameAr,
      ),
      "address_ar": FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(200),
        ],
        value: activity?.addressAr,
      ),
      "description_ar": FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(5000),
          Validators.minLength(10),
        ],
        value: activity?.descriptionAr,
      ),
    });
    super.onInit();
  }

  late final FormGroup firstAddActivityForm;

  late final FormGroup secondAddActivityForm;
  late final FormGroup thirdAddActivityForm;
}
