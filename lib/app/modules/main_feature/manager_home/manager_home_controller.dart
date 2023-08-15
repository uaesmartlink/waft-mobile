import 'package:sport/app/core/models/banner_model.dart';
import 'package:sport/app/core/models/statistics_model.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/services/request_mixin.dart';

import '../../../core/services/getx_state_controller.dart';

class ManagerHomeController extends GetxStateController {
  int carouselSliderIndex = 0;
  final ActivitiesRepository activitiesRepository;
  List<BannerModel>? banners;
  late Statistics allStatistics;
  late Statistics statistics;
  ManagerHomeController({required this.activitiesRepository});
  @override
  void onInit() {
    getBanners();
    getStatistics();
    getAllStatistics();
    super.onInit();
  }

  Future<void> getBanners(
      [RequestType requestType = RequestType.getData]) async {
    await requestMethod(
      ids: ["getBanners"],
      stateLessIds: ["SmoothPageIndicator", "Banners"],
      requestType: requestType,
      showErrorToast: false,
      function: () async {
        banners = await activitiesRepository.getBanners(
            displayFor: "stadium_manager");
        return null;
      },
    );
  }

  Future<void> getAllStatistics(
      [RequestType requestType = RequestType.getData]) async {
    await requestMethod(
      ids: ["getAllStatistics"],
      requestType: requestType,
      showErrorToast: false,
      function: () async {
        allStatistics =
            await activitiesRepository.getStatistics(timePeriod: "all");
        return null;
      },
    );
  }

  String timePeriod = "last_day";

  Future<void> getStatistics(
      [RequestType requestType = RequestType.getData]) async {
    await requestMethod(
      ids: ["getStatistics"],
      requestType: requestType,
      showErrorToast: false,
      function: () async {
        statistics =
            await activitiesRepository.getStatistics(timePeriod: timePeriod);
        return null;
      },
    );
  }

  void changeCarouselSliderIndex(int carouselSliderIndex) {
    this.carouselSliderIndex = carouselSliderIndex;
    update(["SmoothPageIndicator"]);
  }

  Future<void> refreshManagerHomeData() async {
    await getBanners(RequestType.refresh);
    await getStatistics(RequestType.refresh);
    await getAllStatistics(RequestType.refresh);
  }
}
