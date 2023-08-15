import 'package:get/get.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/core/repositories/user_repository.dart';
import 'package:sport/app/core/services/notifications/firebase_cloud_messaging.dart';
import 'package:sport/app/core/utils/exceptions.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';
import 'package:sport/app/modules/auth/auth_module.dart';
import 'package:sport/app/modules/auth/shared/constant/auth_routes.dart';

import '../../../core/services/getx_state_controller.dart';
import '../../../core/services/request_mixin.dart';

class LoginController extends GetxStateController {
  final UserRepository userRepository;
  final ConstantsRepository constantsRepository;

  LoginController({
    required this.userRepository,
    required this.constantsRepository,
  });

  bool obscurePassword = true;
  void changeVisiblePassword() {
    obscurePassword = !obscurePassword;
    update(["LoginView"]);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await requestMethod(
      ids: ["LoginView"],
      requestType: RequestType.getData,
      showErrorToast: false,
      onError: (error) {
        if (error.error == CustomError.emailNotVerified) {
          Get.toNamed(
            AuthRoutes.checkCodeRoute,
            arguments: {"email": email},
          );
        } else {
          CustomToast.showError(error);
        }
      },
      function: () async {
        final String fcmToken =
            await NotificationService.instance.getFcmToken();
        await userRepository.login(
          email: email,
          password: password,
          fcmToken: fcmToken,
        );
        Get.offAllNamed(AuthModule.authInitialRoute);
        return null;
      },
    );
  }
}
