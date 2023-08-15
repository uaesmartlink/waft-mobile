import 'package:get/get.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/core/repositories/user_repository.dart';

import 'profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ProfileController(
        constantsRepository: Get.find<ConstantsRepository>(),
        userRepository: Get.find<UserRepository>(),
      ),
    );
  }
}
