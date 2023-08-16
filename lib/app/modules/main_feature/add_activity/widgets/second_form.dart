import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/widgets/input_fields.dart';
import 'package:sport/app/core/widgets/widget_state.dart';

import '../../../../../app_constants/app_dimensions.dart';

class SecondFormAddActivity extends StatefulWidget {
  const SecondFormAddActivity({
    super.key,
    required this.widgetState,
    required this.formGroup,
  });
  final WidgetState widgetState;
  final FormGroup formGroup;

  @override
  State<SecondFormAddActivity> createState() => _SecondFormAddActivityState();
}

class _SecondFormAddActivityState extends State<SecondFormAddActivity> {
  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: widget.formGroup,
      child: ListView(
        padding: const EdgeInsets.all(AppDimensions.generalPadding),
        children: [
          HeaderTextField(
            widgetState: widget.widgetState,
            formControlName: "name_ar",
            hintText: LanguageKey.enterActivityNameArabic.tr,
            header: LanguageKey.activityNameArabic.tr,
            maxLength: 100,
            keyboardType: TextInputType.text,
            validationMessages: {
              ValidationMessage.required: (_) => LanguageKey.requiredField.tr,
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDimensions.generalPadding),
          HeaderTextField(
            widgetState: widget.widgetState,
            formControlName: "address_ar",
            hintText: LanguageKey.enterAddressArabic.tr,
            header: LanguageKey.addressArabic.tr,
            maxLength: 200,
            keyboardType: TextInputType.text,
            validationMessages: {
              ValidationMessage.required: (_) => LanguageKey.requiredField.tr,
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDimensions.generalPadding),
          HeaderTextField(
            widgetState: widget.widgetState,
            formControlName: "description_ar",
            hintText: LanguageKey.enterDescriptionArabic.tr,
            header: LanguageKey.descriptionArabic.tr,
            maxLength: 5000,
            minLines: 5,
            maxLines: 50,
            keyboardType: TextInputType.text,
            validationMessages: {
              ValidationMessage.required: (_) => LanguageKey.requiredField.tr,
              ValidationMessage.minLength: (_) =>
                  LanguageKey.descriptionLonger.tr,
            },
            textInputAction: TextInputAction.next,
          ),
        ],
      ),
    );
  }
}
