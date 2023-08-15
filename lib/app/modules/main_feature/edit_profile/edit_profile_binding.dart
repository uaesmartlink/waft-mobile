import 'package:get/get.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/core/repositories/user_repository.dart';

import 'edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      EditProfileController(
        userRepository: Get.find<UserRepository>(),
        constantsRepository: Get.find<ConstantsRepository>(),
      ),
    );
  }
}
