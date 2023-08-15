import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/core/repositories/user_repository.dart';
import 'package:sport/app/core/services/notifications/firebase_cloud_messaging.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';
import 'package:sport/app/modules/auth/shared/constant/auth_routes.dart';

import '../../../core/services/getx_state_controller.dart';
import '../../../core/services/request_mixin.dart';

class RegisterController extends GetxStateController {
  final UserRepository userRepository;
  final ConstantsRepository constantsRepository;
  final PageController pageController = PageController();
  RegisterController({
    required this.userRepository,
    required this.constantsRepository,
  });
  bool acceptTerms = false;
  int pageIndex = 0;
  File? profileImage;
  void changePage(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    this.pageIndex = pageIndex;
    update(["RegisterView"]);
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String? phoneNumber,
    required int? gender,
    required DateTime? birthday,
  }) async {
    await requestMethod(
      ids: ["RegisterView"],
      requestType: RequestType.getData,
      function: () async {
        final String fcmToken =
            await NotificationService.instance.getFcmToken();
        await userRepository.register(
          fullName: fullName,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          fcmToken: fcmToken,
          gender: gender,
          birthday: birthday,
          image: profileImage!,
        );
        Get.toNamed(
          AuthRoutes.checkCodeRoute,
          arguments: {"email": email},
        );
        return null;
      },
    );
  }

  Future<void> pickImageGallery() async {
    try {
      final pick = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pick != null) {
        int sizeInBytes = File(pick.path).lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (sizeInMb > 2) {
          AppMessenger.message(LanguageKey.imageSize.tr);
          return;
        }
        profileImage = File(pick.path);
      }
      update(["profile"]);
    } catch (_) {}
  }
}
