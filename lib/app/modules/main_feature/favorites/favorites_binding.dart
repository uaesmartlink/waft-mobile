import 'package:get/get.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/modules/main_feature/favorites/favorites_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      FavoritesController(
        activitiesRepository: Get.find<ActivitiesRepository>(),
        constantsRepository: Get.find<ConstantsRepository>(),
      ),
    );
  }
}
