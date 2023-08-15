import 'package:get/get.dart';
import 'package:sport/app/modules/main_feature/language/language_controller.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      LanguageController(),
    );
  }
}
