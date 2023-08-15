import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/models/activity_type_model.dart';
import 'package:sport/app/core/models/city_model.dart';
import 'package:sport/app/core/models/region_model.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/core/services/data_list_mixin.dart';
import 'package:sport/app/core/services/request_mixin.dart';

import '../../../core/services/getx_state_controller.dart';

enum SearchMode { search, city, category }

class SearchActivitiesController extends GetxStateController
    with DataList<Activity> {
  SearchActivitiesController({
    required this.activitiesRepository,
    required this.constantsRepository,
  });
  final ActivitiesRepository activitiesRepository;
  final ConstantsRepository constantsRepository;
  late final SearchMode searchMode;
  TextEditingController textEditingController = TextEditingController();
  City? selectedCity;
  Region? selectedRegion;
  ActivityType? selectedActivityType;
  int? activityTypeId;
  String? bannerName;
  List<City> cities = [];
  List<ActivityType> activityTypes = [];

  void changeSelectedCity(int cityId) {
    selectedCity = cities.firstWhere(
      (city) => city.id == cityId,
      orElse: () => cities.first,
    );
    update(["header", "getCities", "filterBottomSheet"]);
    if (searchMode != SearchMode.search) {
      getActivities();
    }
  }

  void changeSelectedRegion(int regionId) {
    selectedRegion = regions.firstWhere(
      (region) => region.id == regionId,
      orElse: () => regions.first,
    );
    update(["header", "getRegions"]);
    if (searchMode != SearchMode.search) {
      getActivities();
    }
  }

  void changeSelectedActivityType(int activityTypeId) {
    selectedActivityType = activityTypes.firstWhere(
      (activityType) => activityType.id == activityTypeId,
      orElse: () => activityTypes.first,
    );
    update(["header"]);
    if (searchMode != SearchMode.search) {
      getActivities();
    }
  }

  CancelToken getActivitiesCancelToken = CancelToken();

  Future<void> getActivities(
      [RequestType requestType = RequestType.getData]) async {
    await handelDataList(
      ids: ["getActivities"],
      requestType: requestType,
      function: () async {
        getActivitiesCancelToken.cancel("cancel by next request");
        getActivitiesCancelToken = CancelToken();
        if ((selectedActivityType != null && activityTypes.isNotEmpty) ||
            activityTypeId != null) {
          return await activitiesRepository.getMostBooked(
            activityTypeId: selectedActivityType?.id ?? activityTypeId,
            page: page,
            cancelToken: getActivitiesCancelToken,
          );
        } else if (selectedActivityType != null) {
          return await activitiesRepository.getActivities(
            activityTypeId: selectedActivityType?.id,
            page: page,
            cancelToken: getActivitiesCancelToken,
          );
        } else {
          return await activitiesRepository.getActivities(
            cancelToken: getActivitiesCancelToken,
            cityId: selectedCity?.id,
            activityTypeId:
                selectedActivityType?.id ?? filterSelectedActivityType?.id,
            name: textEditingController.text,
            page: page,
            regionId: selectedRegion?.id,
            minRating: selectedRate,
          );
        }
      },
    );
  }

  Future<bool> addToFavorites({required Activity activity}) async {
    try {
      int id =
          await activitiesRepository.addToFavorites(stadiumId: activity.id);
      activity.favoriteId = id;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeFromFavorites({required int? favoriteId}) async {
    try {
      if (favoriteId != null) {
        await activitiesRepository.removeFromFavorites(favoriteId: favoriteId);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  void changeFilterSelectedActivityType(int activityTypeId) {
    filterSelectedActivityType = filterActivityTypes.firstWhere(
      (activityType) => activityType.id == activityTypeId,
      orElse: () => filterActivityTypes.first,
    );
    update(["getActivityTypes"]);
  }

  void changeFilterSelectedRate(double selectedRate) {
    this.selectedRate = selectedRate;
    update(["Rating"]);
  }

  void resetFilter() {
    filterSelectedActivityType = null;
    selectedRate = null;
    selectedCity = null;
    selectedRegion = null;
    update([
      "getActivityTypes",
      "Rating",
      "getRegions",
      "getCities",
      "filterBottomSheet"
    ]);
  }

  void applyFilter() {
    Get.back();
    getActivities();
  }

  double? selectedRate;
  ActivityType? filterSelectedActivityType;
  List<ActivityType> filterActivityTypes = [];
  Future<void> getActivityTypes(
      [RequestType requestType = RequestType.getData]) async {
    await requestMethod(
      ids: ["getActivityTypes"],
      requestType: requestType,
      showErrorToast: false,
      function: () async {
        if (filterActivityTypes.isEmpty) {
          filterActivityTypes = await constantsRepository.getActivityTypes();
        }

        return null;
      },
    );
  }

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
  Future<void> getRegions() async {
    await requestMethod(
      ids: ["getRegions"],
      requestType: RequestType.getData,
      showErrorToast: false,
      function: () async {
        regions =
            await constantsRepository.getRegions(cityId: selectedCity!.id);
        return null;
      },
    );
  }

  @override
  void onInit() {
    searchMode = Get.arguments["searchMode"];
    cities = Get.arguments["cities"] ?? [];
    activityTypes = Get.arguments["activityTypes"] ?? [];
    selectedCity = Get.arguments["selectedCity"];
    activityTypeId = Get.arguments["activityTypeId"];
    selectedActivityType = Get.arguments["selectedActivityType"];
    bannerName = Get.arguments["bannerName"];
    if (selectedCity != null ||
        selectedActivityType != null ||
        activityTypeId != null) {
      getActivities();
      if (selectedCity != null) {
        getRegions();
      }
    } else {}
    super.onInit();
  }
}
