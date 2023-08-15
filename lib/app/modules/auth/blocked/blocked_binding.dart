import 'package:get/get.dart';
import 'package:sport/app/core/repositories/user_repository.dart';

import 'blocked_controller.dart';

class BlockedBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      BlockedController(userRepository: Get.find<UserRepository>()),
    );
  }
}
