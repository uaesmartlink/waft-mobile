import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/elevated_button.dart';

import '../../../core/widgets/widget_state.dart';
import 'check_code_controller.dart';

class CheckCodeView extends GetView<CheckCodeController> {
  const CheckCodeView({Key? key}) : super(key: key);

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
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return ScreenSizer(builder: (customSize) {
      return SizedBox(
        width: customSize.screenWidth,
        height: customSize.screenHeight,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            children: [
              Image.asset(
                "assets/images/Frame.png",
                width: customSize.screenWidth / 1.6,
                height: customSize.screenWidth / 1.6,
              ),
              Text(
                LanguageKey.verificationCode.tr,
                style: const TextStyle(fontSize: 26, color: AppColors.secondry),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  LanguageKey.enterVerificationCode.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              StateBuilder<CheckCodeController>(
                  id: "checkCodeViewPinCodeTextField",
                  disableState: true,
                  initialWidgetState: WidgetState.loaded,
                  builder: (widgetState, controller) {
                    return Directionality(
                      textDirection: TextDirection.ltr,
                      child: PinCodeTextField(
                        length: 6,
                        cursorColor: AppColors.primary,
                        appContext: context,
                        obscureText: false,
                        enabled: widgetState != WidgetState.loading,
                        backgroundColor: AppColors.background,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.slide,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          borderWidth: 2,
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeColor: AppColors.primary,
                          selectedFillColor: AppColors.splash,
                          selectedColor: AppColors.primary,
                          activeFillColor: AppColors.primary,
                          inactiveColor: AppColors.primary,
                          inactiveFillColor: AppColors.background,
                          disabledColor: AppColors.splash,
                        ),
                        animationDuration: const Duration(milliseconds: 100),
                        enableActiveFill: true,
                        textStyle: TextStyle(
                            color: widgetState != WidgetState.loading
                                ? AppColors.background
                                : AppColors.background),
                        errorAnimationController: controller.errorController,
                        controller: controller.codeController,
                        onCompleted: (_) => controller.checkVerificationCode(),
                        onChanged: (value) {},
                      ),
                    );
                  }),
              const SizedBox(height: 20),
              StateBuilder<CheckCodeController>(
                  id: "checkCodeViewTimer",
                  disableState: true,
                  initialWidgetState: WidgetState.loaded,
                  builder: (widgetState, controller) {
                    if (!controller.showTimer) {
                      return RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(color: AppColors.font),
                          children: [
                            TextSpan(
                              text: LanguageKey.resendAvailability.tr,
                            ),
                            TextSpan(
                              text: ' ${controller.intTimer} ',
                              style: const TextStyle(
                                  color: AppColors.secondry,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text: LanguageKey.seconds.tr,
                                style:
                                    const TextStyle(color: AppColors.secondry)),
                          ],
                        ),
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "${LanguageKey.verificationCodeNotReceived.tr} ",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 5),
                          InkWell(
                            onTap: widgetState == WidgetState.loading
                                ? null
                                : controller.reSendVerificationCode,
                            child: Builder(builder: (context) {
                              return widgetState == WidgetState.loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          color: AppColors.primary))
                                  : Text(
                                      LanguageKey.resend.tr,
                                      style: const TextStyle(
                                          color: AppColors.secondry),
                                    );
                            }),
                          )
                        ],
                      );
                    }
                  }),
              const SizedBox(height: 30),
              StateBuilder<CheckCodeController>(
                id: "checkCodeViewButton",
                disableState: true,
                initialWidgetState: WidgetState.loaded,
                builder: (widgetState, controller) {
                  return SizedBox(
                    height: 45,
                    width: customSize.screenWidth,
                    child: ElevatedStateButton(
                      widgetState: widgetState,
                      onPressed: controller.checkVerificationCode,
                      child: Text(
                        LanguageKey.verify.tr,
                        style: const TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
