import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/widgets/circle_avatar.dart';
import 'package:sport/app/core/widgets/input_fields.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/add_activity/add_activity_controller.dart';

import '../../../../../app_constants/app_assets.dart';
import '../../../../../app_constants/app_dimensions.dart';

class FirstFormAddActivity extends GetView<AddActivityController> {
  const FirstFormAddActivity(
      {super.key, required this.widgetState, required this.formGroup});
  final WidgetState widgetState;
  final FormGroup formGroup;

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: formGroup,
      child: ListView(
        padding: const EdgeInsets.all(AppDimensions.generalPadding),
        children: [
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StateBuilder<AddActivityController>(
                  id: "profile",
                  disableState: true,
                  initialWidgetState: WidgetState.loaded,
                  builder: (widgetState, controller) {
                    ImageProvider? imageProvider =
                        controller.activityImage != null
                            ? FileImage(controller.activityImage!)
                            : controller.activity != null
                                ? NetworkImage(controller.activity!.image)
                                    as ImageProvider
                                : null;
                    return InkWell(
                      onTap: () {
                        controller.pickImageGallery();
                      },
                      child: circleAvatar(
                        radius: 75,
                        image: imageProvider,
                        widgetState: widgetState,
                        icon: Icons.image,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          HeaderTextField(
            widgetState: widgetState,
            formControlName: "email",
            hintText: LanguageKey.enterEmail.tr,
            header: LanguageKey.email.tr,
            maxLength: 40,
            keyboardType: TextInputType.emailAddress,
            validationMessages: {
              ValidationMessage.required: (_) => LanguageKey.requiredField.tr,
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
            widgetState: widgetState,
            formControlName: "phone",
            hintText: LanguageKey.enterPhone.tr,
            header: LanguageKey.phoneNumber.tr,
            maxLength: 40,
            keyboardType: TextInputType.phone,
            validationMessages: {
              "phone": (_) => LanguageKey.invalidPhone.tr,
              ValidationMessage.required: (_) => LanguageKey.requiredField.tr,
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          StateBuilder<AddActivityController>(
            id: "getCities",
            disableState: true,
            initialWidgetState: WidgetState.loaded,
            builder: (fieldState, controller) {
              return StateHeaderDropdownField<int>(
                widgetState: widgetState,
                formControlName: "city_id",
                fieldState: fieldState,
                validationMessages: {
                  ValidationMessage.required: (_) =>
                      LanguageKey.requiredField.tr,
                },
                hintText: LanguageKey.selectCity.tr,
                items: controller.cities
                    .map((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.name),
                        ))
                    .toList(),
                header: LanguageKey.city.tr,
                onRetry: controller.getCities,
                onChanged: (_) {
                  controller.getRegions(
                      cityId: controller.firstAddActivityForm.value["city_id"]
                          as int);
                },
              );
            },
          ),
          const SizedBox(height: 20),
          StateBuilder<AddActivityController>(
            id: "getRegions",
            disableState: true,
            initialWidgetState: WidgetState.loaded,
            builder: (fieldState, controller) {
              return StateHeaderDropdownField<int>(
                widgetState: widgetState,
                formControlName: "region_id",
                fieldState: fieldState,
                validationMessages: {
                  ValidationMessage.required: (_) =>
                      LanguageKey.requiredField.tr,
                },
                hintText: LanguageKey.selectRegion.tr,
                items: controller.regions
                    .map((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.name),
                        ))
                    .toList(),
                header: LanguageKey.region.tr,
                onRetry: () {
                  controller.getRegions(
                      cityId: controller.firstAddActivityForm.value["city_id"]
                          as int);
                },
              );
            },
          ),
          const SizedBox(height: 20),
          StateBuilder<AddActivityController>(
            id: "getActivityTypes",
            disableState: true,
            initialWidgetState: WidgetState.loaded,
            builder: (fieldState, controller) {
              return StateHeaderDropdownField<int>(
                widgetState: widgetState,
                formControlName: "activity_id",
                fieldState: fieldState,
                validationMessages: {
                  ValidationMessage.required: (_) =>
                      LanguageKey.requiredField.tr,
                },
                hintText: LanguageKey.selectActivityType.tr,
                items: controller.activityTypes
                    .map((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.name),
                        ))
                    .toList(),
                header: LanguageKey.activityType.tr,
                onRetry: controller.getActivityTypes,
              );
            },
          ),
          const SizedBox(height: 20),
          HeaderTextField(
            widgetState: widgetState,
            formControlName: "website",
            hintText: LanguageKey.enterWebsiteLink.tr,
            header: LanguageKey.websiteLink.tr,
            maxLength: 100,
            keyboardType: TextInputType.url,
            validationMessages: {
              ValidationMessage.required: (_) => LanguageKey.requiredField.tr,
              'url': (_) => LanguageKey.invalidURL.tr,
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          HeaderTextField(
            widgetState: widgetState,
            formControlName: "map_url",
            hintText: LanguageKey.enterMapLink.tr,
            header: LanguageKey.mapLink.tr,
            maxLength: 100,
            keyboardType: TextInputType.url,
            validationMessages: {
              ValidationMessage.required: (_) => LanguageKey.requiredField.tr,
              'url': (_) => LanguageKey.invalidURL.tr,
            },
            textInputAction: TextInputAction.next,
          ),
        ],
      ),
    );
  }
}
