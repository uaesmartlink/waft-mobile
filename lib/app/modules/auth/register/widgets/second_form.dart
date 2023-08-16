import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/gender_model.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/input_fields.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app_constants/app_assets.dart';

class SecondFormRegister extends StatefulWidget {
  const SecondFormRegister({
    super.key,
    required this.widgetState,
    required this.formGroup,
    required this.onChangeAcceptTerms,
  });
  final WidgetState widgetState;
  final FormGroup formGroup;
  final Function(bool) onChangeAcceptTerms;

  @override
  State<SecondFormRegister> createState() => _SecondFormRegisterState();
}

class _SecondFormRegisterState extends State<SecondFormRegister> {
  bool acceptTerms = false;
  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: widget.formGroup,
      child: Column(
        children: [
          HeaderTextField(
            widgetState: widget.widgetState,
            formControlName: "phone",
            hintText: LanguageKey.enterPhone.tr,
            header: LanguageKey.phoneNumber.tr,
            maxLength: 40,
            keyboardType: TextInputType.phone,
            validationMessages: {
              "phone": (_) => LanguageKey.invalidPhone.tr,
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          ReactiveDatePicker<DateTime>(
            formControlName: "birthday",
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDatePickerMode: DatePickerMode.year,
            builder: (context, picker, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LanguageKey.dateOfBirth.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.fontGray,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    readOnly: true,
                    onTap: () {
                      picker.showPicker();
                    },
                    controller: TextEditingController(
                        text: picker.value == null
                            ? null
                            : DateFormat('yyyy-MM-dd').format(picker.value!)),
                    decoration: InputDecoration(
                      suffixIcon: SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.calendar,
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      hintStyle: const TextStyle(
                          color: AppColors.fontGray, fontSize: 13),
                      hintText: LanguageKey.selectDateOfBirth.tr,
                    ),
                  ),
                ],
              );
            },
            firstDate: DateTime(DateTime.now().year - 100),
            lastDate: DateTime(DateTime.now().year - 3),
          ),
          const SizedBox(height: 20),
          HeaderDropdownField<int?>(
            items: [
              Geder(null, LanguageKey.none.tr),
              Geder(1, LanguageKey.male.tr),
              Geder(2, LanguageKey.female.tr),
            ]
                .map((gender) => DropdownMenuItem(
                      value: gender.id,
                      child: Text(gender.title),
                    ))
                .toList(),
            widgetState: widget.widgetState,
            formControlName: "gender",
            hintText: LanguageKey.selectGender.tr,
            header: LanguageKey.gender.tr,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: acceptTerms,
                onChanged: (value) {
                  if (value != null) {
                    widget.onChangeAcceptTerms(value);
                    acceptTerms = value;
                    setState(() {});
                  }
                },
              ),
              Flexible(
                child: Text(
                  LanguageKey.agreeApplication.tr,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () async {
                  launchUrl(
                    Uri.parse(DataHelper.constants?.termsAndConditions ?? ""),
                    mode: LaunchMode.inAppWebView,
                  );
                },
                child: Text(LanguageKey.termsAndConditions.tr),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
