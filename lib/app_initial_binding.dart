import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/dio/dio_controller.dart';
import 'package:sport/app/core/dio/factory.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/core/repositories/user_repository.dart';

class AppInitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(
      UserRepository(),
      permanent: true,
    );
    Get.put(
      DioFactory.dioSetUp(userRepository: Get.find<UserRepository>()),
      permanent: true,
    );
    Get.put(
      ConstantsRepository(),
      permanent: true,
    );
    Get.put(
      ActivitiesRepository(),
      permanent: true,
    );

    Get.put<DioController>(
      DioController(
        dio: Get.find<Dio>(),
        userRepository: Get.find<UserRepository>(),
      ),
      permanent: true,
    );
  }
}
