import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/repositories/user_repository.dart';
import 'package:sport/app/core/services/notifications/firebase_cloud_messaging.dart';
import 'package:sport/app/modules/auth/auth_module.dart';

import '../../../core/services/getx_state_controller.dart';

class BlockedController extends GetxStateController {
  final UserRepository userRepository;
  BlockedController({required this.userRepository});
  void logout() async {
    BotToast.showLoading();
    await userRepository.deleteUser();
    await NotificationService.instance.deleteToken();
    BotToast.closeAllLoading();
    DataHelper.reset();
    Get.offAllNamed(AuthModule.authInitialRoute);
  }
}
