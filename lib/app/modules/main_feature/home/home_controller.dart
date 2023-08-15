import 'package:dio/dio.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/models/activity_type_model.dart';
import 'package:sport/app/core/models/banner_model.dart';
import 'package:sport/app/core/models/city_model.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/core/services/request_mixin.dart';

import '../../../core/services/getx_state_controller.dart';

class HomeController extends GetxStateController {
  final ConstantsRepository constantsRepository;
  final ActivitiesRepository activitiesRepository;
  int carouselSliderIndex = 0;

  HomeController({
    required this.constantsRepository,
    required this.activitiesRepository,
  });
  @override
  void onInit() {
    getMostPopular();
    getNearby();
    getBanners();
    super.onInit();
  }

  void changeCarouselSliderIndex(int carouselSliderIndex) {
    this.carouselSliderIndex = carouselSliderIndex;
    update(["SmoothPageIndicator"]);
  }

  Future<void> refreshHomeData() async {
    await getBanners(RequestType.refresh);
    await getNearby(RequestType.refresh);
    await getMostPopular(RequestType.refresh);
  }

  void changeSelectedCity(int cityId) {
    selectedCity = cities.firstWhere(
      (city) => city.id == cityId,
      orElse: () => cities.first,
    );
    getNearby();
  }

  List<City> cities = [];
  List<Activity> nearbyActivities = [];
  City? selectedCity;
  CancelToken getNearbyCancelToken = CancelToken();

  Future<void> getNearby(
      [RequestType requestType = RequestType.getData]) async {
    await requestMethod(
      ids: ["getNearby"],
      requestType: requestType,
      showErrorToast: false,
      function: () async {
        getNearbyCancelToken.cancel("cancel by next request");
        getNearbyCancelToken = CancelToken();
        cities = await constantsRepository.getCities();
        selectedCity ??= cities.first;
        nearbyActivities = await activitiesRepository.getActivities(
          cityId: selectedCity?.id,
          cancelToken: getNearbyCancelToken,
        );
        return null;
      },
    );
  }

  void changeSelectedActivityType(int activityTypeId) {
    selectedActivityType = activityTypes.firstWhere(
      (activityType) => activityType.id == activityTypeId,
      orElse: () => activityTypes.first,
    );
    getMostPopular();
  }

  List<ActivityType> activityTypes = [];
  List<Activity> mostPopularActivities = [];
  ActivityType? selectedActivityType;
  CancelToken getMostPopularCancelToken = CancelToken();

  Future<void> getMostPopular(
      [RequestType requestType = RequestType.getData]) async {
    await requestMethod(
      ids: ["getMostPopular"],
      requestType: requestType,
      showErrorToast: false,
      function: () async {
        getMostPopularCancelToken.cancel("cancel by next request");
        getMostPopularCancelToken = CancelToken();
        activityTypes = await constantsRepository.getActivityTypes();
        selectedActivityType ??= activityTypes.first;
        mostPopularActivities = await activitiesRepository.getMostBooked(
          activityTypeId: selectedActivityType?.id,
          cancelToken: getMostPopularCancelToken,
          perPage: 3,
          page: 1,
        );
        return null;
      },
    );
  }

  List<BannerModel>? banners;
  Future<void> getBanners(
      [RequestType requestType = RequestType.getData]) async {
    await requestMethod(
      ids: ["getBanners"],
      stateLessIds: ["SmoothPageIndicator", "Banners"],
      requestType: requestType,
      showErrorToast: false,
      function: () async {
        banners = await activitiesRepository.getBanners(displayFor: "user");
        return null;
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
}
