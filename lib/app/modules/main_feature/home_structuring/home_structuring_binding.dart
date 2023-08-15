import 'package:get/get.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/models/user_model.dart';
import 'package:sport/app/modules/main_feature/home/home_binding.dart';
import 'package:sport/app/modules/main_feature/manager_home/manager_home_binding.dart';

import 'home_structuring_controller.dart';

class HomeStructuringBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeStructuringController());
    if (DataHelper.user?.browsingType == AccountType.manager) {
      ManagerHomeBinding().dependencies();
    } else {
      HomeBinding().dependencies();
    }
  }
}
