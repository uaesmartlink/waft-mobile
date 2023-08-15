import 'package:get/get.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/core/repositories/user_repository.dart';

import 'register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      RegisterController(
        userRepository: Get.find<UserRepository>(),
        constantsRepository: Get.find<ConstantsRepository>(),
      ),
    );
  }
}
