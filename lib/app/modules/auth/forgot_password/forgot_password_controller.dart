import 'dart:async';

import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/repositories/user_repository.dart';

import '../../../core/services/getx_state_controller.dart';
import '../../../core/services/request_mixin.dart';

class ForgotPasswordController extends GetxStateController {
  ForgotPasswordController({
    required this.userRepository,
  });
  final UserRepository userRepository;
  @override
  void onInit() {
    forgotPasswordForm = FormGroup({
      "email": FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(40),
          const EmailValidator(),
        ],
        value: Get.arguments["email"],
      ),
    });
    super.onInit();
  }

  late final FormGroup forgotPasswordForm;
  Future<void> forgotPassword({required String email}) async {
    requestMethod(
      ids: ["ForgotPasswordView"],
      requestType: RequestType.getData,
      loadedMessage: LanguageKey.resetLinkSent.tr,
      function: () async {
        await userRepository.forgotPassword(email: email);
        Get.back();
        return null;
      },
    );
  }
}
