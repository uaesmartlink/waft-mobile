import 'package:get/get.dart';
import 'package:sport/app/core/repositories/user_repository.dart';

import 'check_code_controller.dart';

class CheckCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CheckCodeController(userRepository: Get.find<UserRepository>()),
    );
  }
}
