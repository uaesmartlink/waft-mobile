import 'package:get/get.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/core/repositories/user_repository.dart';

import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      LoginController(
        userRepository: Get.find<UserRepository>(),
        constantsRepository: Get.find<ConstantsRepository>(),
      ),
    );
  }
}
