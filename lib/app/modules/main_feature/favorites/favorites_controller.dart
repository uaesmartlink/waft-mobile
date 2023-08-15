import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/core/services/data_list_mixin.dart';
import 'package:sport/app/core/services/request_mixin.dart';

import '../../../core/services/getx_state_controller.dart';

class FavoritesController extends GetxStateController with DataList<Activity> {
  FavoritesController({
    required this.activitiesRepository,
    required this.constantsRepository,
  });
  final ActivitiesRepository activitiesRepository;
  final ConstantsRepository constantsRepository;

  Future<void> getFavoriteStadiums(
      [RequestType requestType = RequestType.getData]) async {
    await handelDataList(
      ids: ["getFavoriteStadiums"],
      requestType: requestType,
      function: () async {
        return activitiesRepository.getFavoriteStadiums(page: page);
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

  @override
  void onInit() {
    getFavoriteStadiums();
    super.onInit();
  }
}
