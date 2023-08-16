import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/elevated_button.dart';
import 'package:sport/app/core/widgets/input_fields.dart' hide EmailValidator;
import 'package:sport/app/modules/auth/shared/constant/auth_routes.dart';

import '../../../../app_constants/app_dimensions.dart';
import '../../../core/widgets/widget_state.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);
  final loginForm = FormGroup({
    "email": FormControl<String>(
      validators: [
        Validators.required,
        Validators.maxLength(40),
        const EmailValidator(),
      ],
    ),
    "password": FormControl<String>(
      validators: [
        Validators.required,
        Validators.maxLength(40),
      ],
    ),
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenSizer(builder: (CustomSize customSize) {
        return StateBuilder<LoginController>(
          id: "LoginView",
          disableState: true,
          initialWidgetState: WidgetState.loaded,
          builder: (widgetState, controller) {
            return ReactiveForm(
              formGroup: loginForm,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: customSize.setHeight(100),
                  horizontal: 30,
                ),
                children: [
                  Text(
                    LanguageKey.loginAccount.tr,
                    style: const TextStyle(
                      fontSize: 48,
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
                  const SizedBox(height: AppDimensions.generalPadding),
                  HeaderTextField(
                    widgetState: widgetState,
                    formControlName: "password",
                    suffixIcon: InkWell(
                      onTap: controller.changeVisiblePassword,
                      child: Icon(
                        controller.obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: controller.obscurePassword
                            ? null
                            : AppColors.primary,
                      ),
                    ),
                    hintText: LanguageKey.enterPassword.tr,
                    header: LanguageKey.password.tr,
                    maxLength: 40,
                    obscureText: controller.obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    validationMessages: {
                      ValidationMessage.required: (_) =>
                          LanguageKey.passwordRequired.tr,
                    },
                    textInputAction: TextInputAction.send,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.toNamed(
                            AuthRoutes.forgotPasswordRoute,
                            arguments: {
                              "email": loginForm.value["email"] as String?,
                            },
                          );
                        },
                        child: Text(LanguageKey.forgotPassword.tr),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 45,
                    child: ElevatedStateButton(
                      widgetState: widgetState,
                      onPressed: () {
                        if (loginForm.valid) {
                          FocusScope.of(context).unfocus();
                          controller.login(
                            email: loginForm.value["email"] as String,
                            password: loginForm.value["password"] as String,
                          );
                        } else {
                          loginForm.markAllAsTouched();
                        }
                      },
                      child: Text(
                        LanguageKey.signIn.tr,
                        style: const TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LanguageKey.noAccount.tr,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.fontGray),
                      ),
                      TextButton(
                        onPressed: widgetState == WidgetState.loading
                            ? null
                            : () {
                                Get.toNamed(AuthRoutes.registerRoute);
                                // Get.toNamed(AuthRoutes.preRegisterRoute);
                              },
                        child: Text(LanguageKey.signUp.tr),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
