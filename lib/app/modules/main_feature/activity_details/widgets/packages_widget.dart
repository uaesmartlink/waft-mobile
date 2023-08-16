import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/package_model.dart';
import 'package:sport/app/core/services/size_configration.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/elevated_button.dart';
import 'package:sport/app/core/widgets/input_fields.dart';
import 'package:sport/app/core/widgets/no_resulte.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/activity_details/activity_details_controller.dart';

import '../../../../../app_constants/app_dimensions.dart';

class PackagesWidget extends GetView<ActivityDetailsController> {
  const PackagesWidget({required this.packages, super.key});
  final List<Package> packages;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActivityDetailsController>(
      id: "PackagesWidget",
      builder: (_) {
        if (packages.isEmpty) {
          return const NoResults();
        } else {
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(AppDimensions.generalPadding, AppDimensions.generalPadding, AppDimensions.generalPadding, 100),
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              Package package = packages[index];
              return Container(
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
                  title: Text(package.name),
                  subtitle: Text("${package.price} ${LanguageKey.dirhams.tr}"),
                  leading: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      package.packageType == PackageType.timeSlot
                          ? Icons.watch_later_rounded
                          : Icons.subscriptions,
                      color: AppColors.primary,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          deletePackageDialog(
                              context: context, package: package);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          addPackageDialog(
                            context: context,
                            package: package,
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
            itemCount: packages.length,
          );
        }
      },
    );
  }

  void deletePackageDialog({
    required BuildContext context,
    required Package package,
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
                  id: "deletePackageDialog",
                  disableState: true,
                  initialWidgetState: WidgetState.loaded,
                  builder: (widgetState, controller) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${LanguageKey.delete.tr} ${package.name}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          LanguageKey.clientPackage.tr,
                          style: const TextStyle(
                            color: AppColors.fontGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedStateButton(
                            widgetState: widgetState,
                            onPressed: () {
                              controller.deleteStadiumPackage(
                                packageId: package.id,
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
                        const SizedBox(height: 20),
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

void addPackageDialog({
  required BuildContext context,
  Package? package,
}) {
  FormGroup addPackageForm = FormGroup({
    "name_en": FormControl<String>(
      validators: [
        Validators.required,
      ],
      value: package?.name,
    ),
    "name_ar": FormControl<String>(
      validators: [
        Validators.required,
      ],
      value: package?.name,
    ),
    "price": FormControl<int>(
      validators: [
        Validators.required,
        Validators.number,
        Validators.min(1),
      ],
      value: package?.price,
    ),
    "slot": FormControl<int>(
      validators: [
        Validators.required,
        Validators.number,
        Validators.min(1),
      ],
      value: package == null ? null : package.slot ~/ package.slotType.value,
    ),
    "type": FormControl<String>(
      validators: [
        Validators.required,
      ],
      value: package?.getPackageTypeString,
    ),
    "slot_type": FormControl<SlotType>(
      validators: [
        Validators.required,
      ],
      value: package?.slotType ?? SlotType("minutes", 1),
    ),
  });
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: AppColors.background,
        child: ScreenSizer(builder: (CustomSize customSize) {
          return Container(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: StateBuilder<ActivityDetailsController>(
                  id: "addPackageDialog",
                  disableState: true,
                  initialWidgetState: WidgetState.loaded,
                  builder: (widgetState, controller) {
                    return ReactiveForm(
                      formGroup: addPackageForm,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            package != null
                                ? LanguageKey.updatePackage.tr
                                : LanguageKey.addPackage.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          HeaderTextField(
                            widgetState: widgetState,
                            formControlName: "name_ar",
                            hintText: LanguageKey.enterPackageNameArabic.tr,
                            header: LanguageKey.packageNameArabic.tr,
                            maxLength: 200,
                            keyboardType: TextInputType.name,
                            validationMessages: {
                              ValidationMessage.required: (_) =>
                                  LanguageKey.requiredField.tr,
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 20),
                          HeaderTextField(
                            widgetState: widgetState,
                            formControlName: "name_en",
                            hintText: LanguageKey.enterPackageNameEnglish.tr,
                            header: LanguageKey.packageNameEnglish.tr,
                            maxLength: 200,
                            keyboardType: TextInputType.name,
                            validationMessages: {
                              ValidationMessage.required: (_) =>
                                  LanguageKey.requiredField.tr,
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 20),
                          HeaderDropdownField<String>(
                            widgetState: widgetState,
                            formControlName: "type",
                            validationMessages: {
                              ValidationMessage.required: (_) =>
                                  LanguageKey.requiredField.tr,
                            },
                            hintText: LanguageKey.selectPackageType.tr,
                            items: [
                              PackageTypeName(
                                LanguageKey.oneTimeReservation.tr,
                                "time_slot",
                              ),
                              PackageTypeName(
                                LanguageKey.subscription.tr,
                                "subscription",
                              ),
                            ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.value,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            header: LanguageKey.packageType.tr,
                          ),
                          const SizedBox(height: 20),
                          HeaderTextField(
                            widgetState: widgetState,
                            formControlName: "price",
                            hintText: LanguageKey.enterPackagePrice.tr,
                            header: LanguageKey.price.tr,
                            maxLength: 200,
                            keyboardType: TextInputType.number,
                            validationMessages: {
                              ValidationMessage.required: (_) =>
                                  LanguageKey.requiredField.tr,
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: HeaderDropdownField<SlotType>(
                                  widgetState: widgetState,
                                  formControlName: "slot_type",
                                  validationMessages: {
                                    ValidationMessage.required: (_) =>
                                        LanguageKey.requiredField.tr,
                                  },
                                  hintText: LanguageKey.slotType.tr,
                                  items: [
                                    SlotType("minutes", 1),
                                    SlotType("hours", 60),
                                    SlotType("days", 1440),
                                    SlotType("years", 525600),
                                  ]
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e.name.tr),
                                        ),
                                      )
                                      .toList(),
                                  header: LanguageKey.slotType.tr,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: HeaderTextField(
                                  widgetState: widgetState,
                                  formControlName: "slot",
                                  hintText: LanguageKey.enterTimeSlot.tr,
                                  header: LanguageKey.timeSlot.tr,
                                  maxLength: 200,
                                  keyboardType: TextInputType.number,
                                  validationMessages: {
                                    ValidationMessage.required: (_) =>
                                        LanguageKey.requiredField.tr,
                                  },
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: ElevatedStateButton(
                              widgetState: widgetState,
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (addPackageForm.valid) {
                                  if (package == null) {
                                    controller.addStadiumPackage(
                                      price:
                                          addPackageForm.value["price"] as int,
                                      slot: (addPackageForm.value["slot"]
                                              as int) *
                                          ((addPackageForm.value["slot_type"]
                                                  as SlotType)
                                              .value),
                                      nameEn: addPackageForm.value["name_en"]
                                          as String,
                                      nameAr: addPackageForm.value["name_ar"]
                                          as String,
                                      type: addPackageForm.value["type"]
                                          as String,
                                      slotType: (addPackageForm
                                              .value["slot_type"] as SlotType)
                                          .name,
                                    );
                                  } else {
                                    controller.updateStadiumPackage(
                                      packageId: package.id,
                                      price:
                                          addPackageForm.value["price"] as int,
                                      slot: (addPackageForm.value["slot"]
                                              as int) *
                                          ((addPackageForm.value["slot_type"]
                                                  as SlotType)
                                              .value),
                                      nameEn: addPackageForm.value["name_en"]
                                          as String,
                                      nameAr: addPackageForm.value["name_ar"]
                                          as String,
                                      type: addPackageForm.value["type"]
                                          as String,
                                      slotType: (addPackageForm
                                              .value["slot_type"] as SlotType)
                                          .name,
                                    );
                                  }
                                } else {
                                  addPackageForm.markAllAsTouched();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                backgroundColor: AppColors.primary,
                              ),
                              child: Text(
                                package != null
                                    ? LanguageKey.update.tr
                                    : LanguageKey.add.tr,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
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
          );
        }),
      );
    },
  );
}
