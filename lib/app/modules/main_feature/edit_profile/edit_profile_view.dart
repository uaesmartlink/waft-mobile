import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/gender_model.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/circle_avatar.dart';
import 'package:sport/app/core/widgets/elevated_button.dart';
import 'package:sport/app/core/widgets/input_fields.dart';
import 'package:sport/app/modules/main_feature/shared/constant/home_routes.dart';

import '../../../../app_constants/app_assets.dart';
import '../../../../app_constants/app_dimensions.dart';
import '../../../core/widgets/widget_state.dart';
import 'edit_profile_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  @override
  Widget build(BuildContext context) {
    return StateBuilder<EditProfileController>(
      id: "EditProfileView",
      disableState: true,
      initialWidgetState: WidgetState.loaded,
      builder: (widgetState, controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              LanguageKey.editProfile.tr,
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
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.font,
              ),
            ),
          ),
          floatingActionButton: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width - 40,
            child: ElevatedStateButton(
              widgetState: widgetState,
              onPressed: () {
                if (controller.editProfileForm.valid) {
                  FocusScope.of(context).unfocus();
                  String? processedPhoneNumber =
                      controller.editProfileForm.value["phone"] as String?;
                  if (processedPhoneNumber != null) {
                    processedPhoneNumber =
                        '+971${processedPhoneNumber.startsWith('0') ? processedPhoneNumber.substring(1) : processedPhoneNumber}';
                  }
                  controller.updateProfile(
                    fullName:
                        controller.editProfileForm.value["name"] as String,
                    phoneNumber: processedPhoneNumber,
                    gender: controller.editProfileForm.value["gender"] as int?,
                    birthday: controller.editProfileForm.value["birthday"]
                        as DateTime?,
                  );
                } else {
                  controller.editProfileForm.markAllAsTouched();
                }
              },
              child: Text(
                LanguageKey.update.tr,
                style: const TextStyle(
                  color: AppColors.background,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          body: ScreenSizer(builder: (CustomSize customSize) {
            return ReactiveForm(
              formGroup: controller.editProfileForm,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppDimensions.generalPadding, AppDimensions.generalPadding, AppDimensions.generalPadding, 70),
                children: [
                  SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StateBuilder<EditProfileController>(
                          id: "profile",
                          disableState: true,
                          initialWidgetState: WidgetState.loaded,
                          builder: (widgetState, controller) {
                            return InkWell(
                              onTap: () {
                                controller.pickImageGallery();
                              },
                              child: circleAvatarNetwork(
                                radius: 75,
                                imageUrl: DataHelper.user!.image,
                                image: controller.profileImage,
                                widgetState: widgetState,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.generalPadding),
                  HeaderTextField(
                    widgetState: widgetState,
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
                  const SizedBox(height: AppDimensions.generalPadding),
                  HeaderTextField(
                    widgetState: WidgetState.loading,
                    formControlName: "email",
                    onTap: () {
                      Get.toNamed(HomeRoutes.changeEmailRoute);
                    },
                    hintText: LanguageKey.enterEmail.tr,
                    header: LanguageKey.email.tr,
                    maxLength: 40,
                    keyboardType: TextInputType.emailAddress,
                    validationMessages: {
                      ValidationMessage.required: (_) =>
                          LanguageKey.emailRequired.tr,
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
                  const SizedBox(height: AppDimensions.generalPadding),
                  HeaderTextField(
                    widgetState: widgetState,
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
                  const SizedBox(height: AppDimensions.generalPadding),
                  ReactiveDatePicker<DateTime>(
                    formControlName: "birthday",
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
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
                                    : DateFormat('yyyy-MM-dd')
                                        .format(picker.value!)),
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
                  const SizedBox(height: AppDimensions.generalPadding),
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
                    widgetState: widgetState,
                    formControlName: "gender",
                    hintText: LanguageKey.selectGender.tr,
                    header: LanguageKey.gender.tr,
                  ),
                  const SizedBox(height: AppDimensions.generalPadding),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
