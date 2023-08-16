import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/service_model.dart';
import 'package:sport/app/core/models/user_model.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/elevated_button.dart';
import 'package:sport/app/core/widgets/input_fields.dart';
import 'package:sport/app/core/widgets/no_resulte.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/activity_details/activity_details_controller.dart';

import '../../../../../app_constants/app_dimensions.dart';

class ServicesWidget extends GetView<ActivityDetailsController> {
  const ServicesWidget({required this.services, super.key});
  final List<ServiceModel> services;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActivityDetailsController>(
      id: "ServicesWidget",
      builder: (_) {
        if (services.isEmpty) {
          return const NoResults();
        } else {
          return ListView.separated(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(AppDimensions.generalPadding, AppDimensions.generalPadding, AppDimensions.generalPadding, 100),
            itemBuilder: (context, index) {
              ServiceModel serviceModel = services[index];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(1, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text(serviceModel.name),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.background,
                    foregroundImage: CachedNetworkImageProvider(serviceModel
                            .icon ??
                        "https://api.waft.ae/storage/images/icons/JI2hFoUt3I6BTynALXuuXbvTVuvXtvLCV46BWw23.png"),
                  ),
                  trailing: DataHelper.user?.browsingType == AccountType.manager
                      ? IconButton(
                          onPressed: () {
                            deleteServiceDialog(
                              context: context,
                              serviceModel: serviceModel,
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.red,
                          ),
                        )
                      : null,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
            itemCount: services.length,
          );
        }
      },
    );
  }

  void deleteServiceDialog({
    required BuildContext context,
    required ServiceModel serviceModel,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: AppColors.background,
          child: Container(
            padding: const EdgeInsets.all(30),
            width: MediaQuery.of(context).size.width - 100,
            child: SingleChildScrollView(
              child: StateBuilder<ActivityDetailsController>(
                  id: "deleteServiceDialog",
                  disableState: true,
                  initialWidgetState: WidgetState.loaded,
                  builder: (widgetState, controller) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${LanguageKey.delete.tr} ${serviceModel.name}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          LanguageKey.clientService.tr,
                          style: const TextStyle(
                            color: AppColors.fontGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.generalPadding),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedStateButton(
                            widgetState: widgetState,
                            onPressed: () {
                              controller.deleteStadiumServices(
                                serviceId: serviceModel.id,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: AppColors.red,
                            ),
                            child: Text(
                              LanguageKey.delete.tr,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.generalPadding),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Get.back(),
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: AppColors.splash,
                            ),
                            child: Text(
                              LanguageKey.cancel.tr,
                              style: const TextStyle(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        );
      },
    );
  }
}

void addServiceDialog({
  required BuildContext context,
}) {
  FormGroup addServiceForm = FormGroup({
    "service_id": FormControl<int>(
      validators: [
        Validators.required,
      ],
    ),
  });
  Get.find<ActivityDetailsController>().getServices();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: AppColors.background,
        child: Container(
          padding: const EdgeInsets.all(30),
          width: MediaQuery.of(context).size.width - 100,
          child: SingleChildScrollView(
            child: StateBuilder<ActivityDetailsController>(
                id: "addServiceDialog",
                disableState: true,
                initialWidgetState: WidgetState.loaded,
                builder: (widgetState, controller) {
                  return ReactiveForm(
                    formGroup: addServiceForm,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          LanguageKey.addService.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.generalPadding),
                        StateBuilder<ActivityDetailsController>(
                          id: "getServices",
                          disableState: true,
                          initialWidgetState: WidgetState.loaded,
                          builder: (fieldState, controller) {
                            return StateHeaderDropdownField<int>(
                              widgetState: widgetState,
                              formControlName: "service_id",
                              fieldState: fieldState,
                              validationMessages: {
                                ValidationMessage.required: (_) =>
                                    LanguageKey.requiredField.tr,
                              },
                              hintText: LanguageKey.selectServiceType.tr,
                              items: controller.services
                                  .map((e) => DropdownMenuItem(
                                        value: e.id,
                                        child: Text(e.name),
                                      ))
                                  .toList(),
                              header: LanguageKey.serviceType.tr,
                              onRetry: controller.getServices,
                            );
                          },
                        ),
                        const SizedBox(height: AppDimensions.generalPadding),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedStateButton(
                            widgetState: widgetState,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (addServiceForm.valid) {
                                controller.addStadiumServices(
                                  serviceId:
                                      addServiceForm.value["service_id"] as int,
                                );
                              } else {
                                addServiceForm.markAllAsTouched();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: AppColors.primary,
                            ),
                            child: Text(
                              LanguageKey.add.tr,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.generalPadding),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Get.back(),
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: AppColors.splash,
                            ),
                            child: Text(
                              LanguageKey.cancel.tr,
                              style: const TextStyle(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      );
    },
  );
}
