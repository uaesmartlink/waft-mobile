import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/repositories/user_repository.dart';
import 'package:sport/app/core/utils/exceptions.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';
import 'package:sport/app/modules/auth/auth_module.dart';

import '../../../core/services/getx_state_controller.dart';
import '../../../core/services/request_mixin.dart';

class CheckCodeController extends GetxStateController {
  CheckCodeController({
    required this.userRepository,
  });
  final UserRepository userRepository;
  late StreamController<ErrorAnimationType> errorController;
  final TextEditingController codeController = TextEditingController();
  late final String email;
  late final bool changeEmail;
  int intTimer = 0;
  @override
  void onInit() {
    email = Get.arguments["email"];
    changeEmail = Get.arguments["changeEmail"] ?? false;
    errorController = StreamController<ErrorAnimationType>();
    startTimer(true);
    super.onInit();
  }

  Future<void> reSendVerificationCode() async {
    requestMethod(
      ids: ["checkCodeViewTimer", "checkCodeViewPinCodeTextField"],
      requestType: RequestType.getData,
      function: () async {
        try {
          startTimer(false);
          if (changeEmail) {
            await userRepository.changeEmail(email: email);
          } else {
            await userRepository.resendVerificationCode(email: email);
          }
        } on CustomException catch (e) {
          CustomToast.showError(e);
        }
        return null;
      },
    );
  }

  Future<void> checkVerificationCode() async {
    if (codeController.text.length == 6) {
      requestMethod(
        ids: ["checkCodeViewButton", "checkCodeViewPinCodeTextField"],
        requestType: RequestType.getData,
        function: () async {
          try {
            if (changeEmail) {
              await userRepository.updateEmail(
                email: email,
                code: codeController.text,
                user: DataHelper.user!,
              );
            } else {
              await userRepository.checkVerificationCode(
                email: email,
                code: codeController.text,
              );
            }

            Get.offAllNamed(AuthModule.authInitialRoute);
          } on CustomException catch (e) {
            errorController.add(ErrorAnimationType.shake);
            CustomToast.showError(e);
          }
          return null;
        },
      );
    } else {
      errorController.add(ErrorAnimationType.shake);
    }
  }

  late Timer resendCodeTimer;
  void startTimer(bool firstTime) {
    intTimer = firstTime ? 0 : 120;
    resendCodeTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (intTimer > 0) {
        intTimer--;
        update(["checkCodeViewTimer"]);
      } else {
        resendCodeTimer.cancel();
      }
    });
  }

  bool get showTimer => intTimer == 0;
  @override
  void onClose() {
    if (intTimer != 0) {
      resendCodeTimer.cancel();
    }
    errorController.close();
    super.onClose();
  }

  void wrongNumber() {
    Get.back();
  }
}
