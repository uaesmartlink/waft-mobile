import 'package:get/get.dart';

import 'pre_register_controller.dart';

class PreRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PreRegisterController());
  }
}
