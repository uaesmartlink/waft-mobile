import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';
import 'package:sport/app/core/widgets/circle_avatar.dart';
import 'package:sport/app/core/widgets/elevated_button.dart';
import 'package:sport/app/core/widgets/input_fields.dart' hide EmailValidator;
import 'package:sport/app/modules/auth/register/widgets/first_form.dart';
import 'package:sport/app/modules/auth/register/widgets/second_form.dart';

import '../../../../app_constants/app_dimensions.dart';
import '../../../core/widgets/widget_state.dart';
import 'register_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final registerFirstForm = FormGroup({
    "email": FormControl<String>(
      validators: [
        Validators.required,
        Validators.maxLength(40),
        const EmailValidator(),
      ],
    ),
    "name": FormControl<String>(
      validators: [
        Validators.required,
        Validators.maxLength(40),
        Validators.minLength(3),
      ],
    ),
    "password": FormControl<String>(
      validators: [
        Validators.required,
        Validators.maxLength(40),
        Validators.minLength(8),
      ],
    ),
    "confirm_password": FormControl<String>(
      validators: [
        Validators.required,
        Validators.maxLength(40),
      ],
    ),
  }, validators: [
    Validators.mustMatch("password", "confirm_password"),
  ]);
  final registerSecondForm = FormGroup(
    {
      "phone": FormControl<String>(
        validators: [
          const PhoneValidator(),
        ],
      ),
      "gender": FormControl<int?>(),
      "birthday": FormControl<DateTime>(),
    },
  );
  @override
  Widget build(BuildContext context) {
    return StateBuilder<RegisterController>(
      id: "RegisterView",
      disableState: true,
      initialWidgetState: WidgetState.loaded,
      builder: (widgetState, controller) {
        return WillPopScope(
          onWillPop: () async {
            if (controller.pageIndex == 1) {
              FocusScope.of(context).unfocus();
              controller.changePage(0);
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                LanguageKey.fillProfile.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppColors.font,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: InkWell(
                onTap: () {
                  if (controller.pageIndex == 1) {
                    FocusScope.of(context).unfocus();
                    controller.changePage(0);
                  } else {
                    Get.back();
                  }
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.font,
                ),
              ),
            ),
            floatingActionButton: controller.pageIndex == 0
                ? SizedBox(
                    width: 65,
                    height: 65,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () async {
                        if (registerFirstForm.valid) {
                          FocusScope.of(context).unfocus();
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          controller.acceptTerms = false;
                          controller.changePage(1);
                        } else {
                          registerFirstForm.markAllAsTouched();
                        }
                      },
                      child: const Icon(
                        Icons.navigate_next_rounded,
                        size: 50,
                      ),
                    ),
                  )
                : SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 40,
                    child: ElevatedStateButton(
                      widgetState: widgetState,
                      onPressed: () {
                        if (controller.profileImage == null) {
                          AppMessenger.message(LanguageKey.choosePhoto.tr);
                          return;
                        }
                        if (!controller.acceptTerms) {
                          AppMessenger.message(LanguageKey.agreeTerms.tr);
                          return;
                        }
                        if (registerSecondForm.valid) {
                          FocusScope.of(context).unfocus();
                          String? processedPhoneNumber =
                              registerSecondForm.value["phone"] as String?;
                          if (processedPhoneNumber != null &&
                              processedPhoneNumber != "") {
                            processedPhoneNumber =
                                '+971${processedPhoneNumber.startsWith('0') ? processedPhoneNumber.substring(1) : processedPhoneNumber}';
                          } else {
                            processedPhoneNumber = null;
                          }
                          controller.register(
                            fullName: registerFirstForm.value["name"] as String,
                            email: registerFirstForm.value["email"] as String,
                            password:
                                registerFirstForm.value["password"] as String,
                            phoneNumber: processedPhoneNumber,
                            gender: registerSecondForm.value["gender"] as int?,
                            birthday: registerSecondForm.value["birthday"]
                                as DateTime?,
                          );
                        } else {
                          registerSecondForm.markAllAsTouched();
                        }
                      },
                      child: Text(
                        LanguageKey.register.tr,
                        style: const TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
            body: ScreenSizer(
                constHeight: 150,
                builder: (CustomSize customSize) {
                  return ListView(
                    padding: const EdgeInsets.all(AppDimensions.generalPadding),
                    children: [
                      SizedBox(
                        height: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StateBuilder<RegisterController>(
                              id: "profile",
                              disableState: true,
                              initialWidgetState: WidgetState.loaded,
                              builder: (widgetState, controller) {
                                return InkWell(
                                  onTap: () {
                                    controller.pickImageGallery();
                                  },
                                  child: circleAvatar(
                                    radius: 75,
                                    image: controller.profileImage != null
                                        ? FileImage(controller.profileImage!)
                                        : null,
                                    widgetState: widgetState,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 600,
                        child: PageView(
                          controller: controller.pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            FirstFormRegister(
                              widgetState: widgetState,
                              formGroup: registerFirstForm,
                            ),
                            SecondFormRegister(
                              widgetState: widgetState,
                              formGroup: registerSecondForm,
                              onChangeAcceptTerms: (value) {
                                controller.acceptTerms = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ),
        );
      },
    );
  }
}
