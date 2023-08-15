import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/elevated_button.dart';
import 'package:sport/app/core/widgets/input_fields.dart';

import '../../../core/widgets/widget_state.dart';
// ignore: unused_import
import 'change_email_controller.dart';

class ChangeEmailView extends GetView<ChangeEmailController> {
  const ChangeEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.font,
          ),
        ),
      ),
      body: ScreenSizer(
        builder: (customSize) {
          return SizedBox(
            width: customSize.screenWidth,
            height: customSize.screenHeight,
            child: StateBuilder<ChangeEmailController>(
                id: "ChangeEmailView",
                disableState: true,
                initialWidgetState: WidgetState.loaded,
                builder: (widgetState, controller) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      vertical: customSize.setHeight(70),
                      horizontal: 30,
                    ),
                    child: ReactiveForm(
                      formGroup: controller.changeEmailForm,
                      child: Column(
                        children: [
                          Text(
                            LanguageKey.changeEmail.tr,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: customSize.setHeight(60)),
                          HeaderTextField(
                            widgetState: widgetState,
                            formControlName: "email",
                            hintText: LanguageKey.enterEmail.tr,
                            header: LanguageKey.email.tr,
                            maxLength: 40,
                            keyboardType: TextInputType.emailAddress,
                            validationMessages: {
                              ValidationMessage.required: (_) =>
                                  LanguageKey.emailRequired.tr,
                              "email": (_) => LanguageKey.invalidEmail.tr,
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            height: 45,
                            width: customSize.screenWidth,
                            child: ElevatedStateButton(
                              widgetState: widgetState,
                              onPressed: () {
                                if (controller.changeEmailForm.valid) {
                                  FocusScope.of(context).unfocus();
                                  controller.changeEmail(
                                    email: controller.changeEmailForm
                                        .value["email"] as String,
                                  );
                                } else {
                                  controller.changeEmailForm.markAllAsTouched();
                                }
                              },
                              child: Text(
                                LanguageKey.send.tr,
                                style: const TextStyle(
                                  color: AppColors.background,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
