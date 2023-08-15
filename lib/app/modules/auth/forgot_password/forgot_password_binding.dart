import 'package:get/get.dart';
import 'package:sport/app/core/repositories/user_repository.dart';

import 'forgot_password_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () =>
          ForgotPasswordController(userRepository: Get.find<UserRepository>()),
    );
  }
}
