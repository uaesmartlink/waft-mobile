import 'package:get/get.dart';
import 'package:sport/app/core/repositories/user_repository.dart';

import 'change_email_controller.dart';

class ChangeEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ChangeEmailController(userRepository: Get.find<UserRepository>()),
    );
  }
}
