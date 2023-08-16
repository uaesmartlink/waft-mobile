import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/input_fields.dart';
import 'package:sport/app/core/widgets/widget_state.dart';

import '../../../../../app_constants/app_assets.dart';

class FirstFormRegister extends StatefulWidget {
  const FirstFormRegister(
      {super.key, required this.widgetState, required this.formGroup});
  final WidgetState widgetState;
  final FormGroup formGroup;

  @override
  State<FirstFormRegister> createState() => _FirstFormRegisterState();
}

class _FirstFormRegisterState extends State<FirstFormRegister> {
  bool obscurePassword = true;
  void changeVisiblePassword() {
    obscurePassword = !obscurePassword;
    setState(() {});
  }

  bool obscureConfirmPassword = true;
  void changeVisibleConfirmPassword() {
    obscureConfirmPassword = !obscureConfirmPassword;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: widget.formGroup,
      child: Column(
        children: [
          HeaderTextField(
            widgetState: widget.widgetState,
            formControlName: "name",
            hintText: LanguageKey.enterFullName.tr,
            header: LanguageKey.fullName.tr,
            maxLength: 40,
            keyboardType: TextInputType.name,
            validationMessages: {
              ValidationMessage.required: (_) =>
                  LanguageKey.fullNameRequired.tr,
              ValidationMessage.minLength: (_) =>
                  LanguageKey.invalidFullName.tr,
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          HeaderTextField(
            widgetState: widget.widgetState,
            formControlName: "email",
            hintText: LanguageKey.enterEmail.tr,
            header: LanguageKey.email.tr,
            maxLength: 40,
            keyboardType: TextInputType.emailAddress,
            validationMessages: {
              ValidationMessage.required: (_) => LanguageKey.emailRequired.tr,
              "email": (_) => LanguageKey.invalidEmail.tr,
            },
            suffixIcon: Center(
              child: SvgPicture.asset(
                AppAssets.message,
                width: 30,
                height: 30,
              ),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          HeaderTextField(
            widgetState: widget.widgetState,
            formControlName: "password",
            suffixIcon: SizedBox(
              child: InkWell(
                onTap: changeVisiblePassword,
                child: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: obscurePassword ? null : AppColors.primary,
                ),
              ),
            ),
            hintText: LanguageKey.enterPassword.tr,
            header: LanguageKey.password.tr,
            maxLength: 40,
            obscureText: obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            validationMessages: {
              ValidationMessage.required: (_) =>
                  LanguageKey.passwordRequired.tr,
              ValidationMessage.minLength: (_) => LanguageKey.passwordLong.tr,
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          HeaderTextField(
            widgetState: widget.widgetState,
            formControlName: "confirm_password",
            suffixIcon: InkWell(
              onTap: changeVisibleConfirmPassword,
              child: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: obscureConfirmPassword ? null : AppColors.primary,
              ),
            ),
            hintText: LanguageKey.reEnterPassword.tr,
            header: LanguageKey.cnfirmPassword.tr,
            maxLength: 40,
            obscureText: obscureConfirmPassword,
            keyboardType: TextInputType.visiblePassword,
            validationMessages: {
              ValidationMessage.required: (_) =>
                  LanguageKey.confirmPasswordRequired.tr,
              ValidationMessage.mustMatch: (_) =>
                  LanguageKey.passwordsDoNotMatch.tr,
            },
            textInputAction: TextInputAction.send,
          ),
        ],
      ),
    );
  }
}
