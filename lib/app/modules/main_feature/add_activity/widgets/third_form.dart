import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/widgets/input_fields.dart';
import 'package:sport/app/core/widgets/widget_state.dart';

class ThirdFormAddActivity extends StatefulWidget {
  const ThirdFormAddActivity(
      {super.key, required this.widgetState, required this.formGroup});
  final WidgetState widgetState;
  final FormGroup formGroup;

  @override
  State<ThirdFormAddActivity> createState() => _ThirdFormAddActivityState();
}

class _ThirdFormAddActivityState extends State<ThirdFormAddActivity> {
  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: widget.formGroup,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
        children: [
          HeaderTextField(
            widgetState: widget.widgetState,
            formControlName: "name_en",
            hintText: LanguageKey.enterActivityNameEnglish.tr,
            header: LanguageKey.activityNameEnglish.tr,
            maxLength: 100,
            keyboardType: TextInputType.text,
            validationMessages: {
              ValidationMessage.required: (_) => LanguageKey.requiredField.tr,
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          HeaderTextField(
            widgetState: widget.widgetState,
            formControlName: "address_en",
            hintText: LanguageKey.enterAddressEnglish.tr,
            header: LanguageKey.addressEnglish.tr,
            maxLength: 200,
            keyboardType: TextInputType.text,
            validationMessages: {
              ValidationMessage.required: (_) => LanguageKey.requiredField.tr,
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          HeaderTextField(
            widgetState: widget.widgetState,
            formControlName: "description_en",
            hintText: LanguageKey.enterDescriptionEnglish.tr,
            header: LanguageKey.descriptionEnglish.tr,
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
