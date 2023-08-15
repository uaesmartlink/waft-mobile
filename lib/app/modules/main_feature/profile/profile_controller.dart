import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/core/repositories/user_repository.dart';
import 'package:sport/app/core/services/notifications/firebase_cloud_messaging.dart';
import 'package:sport/app/core/services/request_mixin.dart';
import 'package:sport/app/modules/auth/auth_module.dart';

import '../../../core/services/getx_state_controller.dart';

class ProfileController extends GetxStateController {
  final ConstantsRepository constantsRepository;
  final UserRepository userRepository;

  ProfileController({
    required this.constantsRepository,
    required this.userRepository,
  });

  Future<void> logout() async {
    try {
      BotToast.showLoading();
      await userRepository.deleteUser();
      DataHelper.reset();
      await NotificationService.instance.deleteToken();
      BotToast.closeAllLoading();
      Get.offAllNamed(AuthModule.authInitialRoute);
    } catch (e) {
      BotToast.closeAllLoading();
    }
  }

  Future<void> deleteAccount({required String password}) async {
    requestMethod(
      ids: ["deleteAccount"],
      errorMessage: "The provided credentials are incorrect.".tr,
      requestType: RequestType.getData,
      function: () async {
        await userRepository.deleteAccount(
          password: password,
        );
        Get.back();
        await userRepository.deleteUser();
        DataHelper.reset();
        await NotificationService.instance.deleteToken();
        Get.offAllNamed(AuthModule.authInitialRoute);
        return null;
      },
    );
  }

  Future<void> updateProfile({
    String? role,
    String? browsingMode,
  }) async {
    await requestMethod(
      ids: ["partnerDialog"],
      requestType: RequestType.getData,
      showLoading: role == null && browsingMode != null,
      function: () async {
        await userRepository.updateProfile(
          token: DataHelper.user!.token,
          role: role ?? DataHelper.user!.roleName,
          browsingMode: browsingMode ?? DataHelper.user!.browsingTypeName,
          expiresInDate: DataHelper.user!.expiresInDate,
          fullName: DataHelper.user!.name,
          birthday: DataHelper.user!.birthday,
          gender: DataHelper.user!.getGenderString,
          phoneNumber: DataHelper.user!.phone,
        );
        Get.offAllNamed(AuthModule.authInitialRoute);
        return null;
      },
    );
  }
}
