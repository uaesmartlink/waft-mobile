import 'dart:async';

import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/repositories/user_repository.dart';
import 'package:sport/app/modules/auth/shared/constant/auth_routes.dart';

import '../../../core/services/getx_state_controller.dart';
import '../../../core/services/request_mixin.dart';

class ChangeEmailController extends GetxStateController {
  ChangeEmailController({
    required this.userRepository,
  });
  final UserRepository userRepository;
  @override
  void onInit() {
    changeEmailForm = FormGroup({
      "email": FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(40),
          const EmailValidator(),
        ],
      ),
    });
    super.onInit();
  }

  late final FormGroup changeEmailForm;
  Future<void> changeEmail({required String email}) async {
    requestMethod(
      ids: ["ChangeEmailView"],
      requestType: RequestType.getData,
      function: () async {
        await userRepository.changeEmail(email: email);
        Get.toNamed(
          AuthRoutes.checkCodeRoute,
          arguments: {
            "email": email,
            "changeEmail": true,
          },
        );
        return null;
      },
    );
  }
}
