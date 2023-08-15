import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/repositories/user_repository.dart';
import 'package:sport/app/core/services/notifications/firebase_cloud_messaging.dart';
import 'package:sport/app/core/utils/logger.dart';
import 'package:sport/app/modules/auth/auth_module.dart';

import '../constants/request_routes.dart';

class DioController {
  DioController({
    required this.dio,
    required this.userRepository,
  });

  final Dio dio;
  final UserRepository userRepository;
  List<String> urlWithoutToken = [
    // RequestRoutes.refreshToken,
    RequestRoutes.settings,
    RequestRoutes.login,
    RequestRoutes.checkActivationCode,
    RequestRoutes.register,
    RequestRoutes.uploadImages,
    RequestRoutes.start,
  ];

  Future<String?> checkToken({
    required String url,
    required String method,
    bool shouldRefresh = false,
  }) async {
    try {
      if (urlWithoutToken.contains(url) || DataHelper.user == null) {
        logger(DataHelper.user.toString());
        return null;
      } else {
        final bool tokenExpired = DateTime.now().isAfter(DataHelper
            .user!.expiresInDate
            .subtract(const Duration(seconds: 30)));
        if ((shouldRefresh || tokenExpired) &&
            url != RequestRoutes.refreshToken) {
          String? token = await userRepository.refreshToken();
          if (token != null) {
            DataHelper.user = DataHelper.user!.copyWith(
              token: token,
              expiresInDate: DateTime.now().add(const Duration(hours: 1)),
            );

            return token;
          } else {
            BotToast.showLoading();
            await userRepository.deleteUser();
            DataHelper.reset();
            await NotificationService.instance.deleteToken();
            BotToast.closeAllLoading();
            Get.offAllNamed(AuthModule.authInitialRoute);
            return null;
          }
        } else {
          return DataHelper.user!.token;
        }
      }
    } catch (e) {
      return null;
    }
  }
}
