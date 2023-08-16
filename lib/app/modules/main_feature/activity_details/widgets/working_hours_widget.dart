import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/worktime_model.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/elevated_button.dart';
import 'package:sport/app/core/widgets/input_fields.dart';
import 'package:sport/app/core/widgets/no_resulte.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/activity_details/activity_details_controller.dart';

import '../../../../../app_constants/app_dimensions.dart';

class WorkingHoursWidget extends GetView<ActivityDetailsController> {
  const WorkingHoursWidget({required this.workTimes, super.key});
  final List<WorkTime> workTimes;

  @override
  Widget build(BuildContext context) {
    if (workTimes.isEmpty) {
      return const NoResults();
    } else {
      return ListView.separated(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(AppDimensions.generalPadding, AppDimensions.generalPadding, AppDimensions.generalPadding, 100),
        itemBuilder: (context, index) {
          WorkTime workTime = workTimes[index];
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
              title: Text(workTime.day.tr),
              subtitle: Row(
                children: [
                  Text(
                    workTime.startTime
                        .substring(0, workTime.startTime.length - 3),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    " - ",
                  ),
                  Text(
                    workTime.endTime.substring(0, workTime.endTime.length - 3),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      deleteWorkTimeDialog(
                          context: context, workTime: workTime);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: AppColors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      addWorkTimeDialog(
                        context: context,
                        workTime: workTime,
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
        itemCount: workTimes.length,
      );
    }
  }

  void deleteWorkTimeDialog({
    required BuildContext context,
    required WorkTime workTime,
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
                  id: "deleteWorkTimeDialog",
                  disableState: true,
                  initialWidgetState: WidgetState.loaded,
                  builder: (widgetState, controller) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${LanguageKey.delete.tr} ${workTime.day}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          LanguageKey.clientWorkTime.tr,
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
                              controller.deleteWorkTime(
                                workTimeId: workTime.id,
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

void addWorkTimeDialog({
  required BuildContext context,
  WorkTime? workTime,
}) {
  TimeOfDay parseTimeOfDay(String timeString) {
    List<String> parts = timeString.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  FormGroup addServiceForm = FormGroup({
    "day": FormControl<String>(
      validators: [
        Validators.required,
      ],
      value: workTime?.day,
    ),
    "start_time": FormControl<TimeOfDay>(
      validators: [
        Validators.required,
      ],
      value: workTime != null
          ? parseTimeOfDay(workTime.startTime)
          : const TimeOfDay(hour: 8, minute: 0),
    ),
    "end_time": FormControl<TimeOfDay>(
      validators: [
        Validators.required,
      ],
      value: workTime != null
          ? parseTimeOfDay(workTime.endTime)
          : const TimeOfDay(hour: 18, minute: 0),
    ),
  });
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
                id: "addWorkTimeDialog",
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
                          workTime == null
                              ? LanguageKey.addWorkTime.tr
                              : LanguageKey.updateWorkTime.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.generalPadding),
                        HeaderDropdownField<String>(
                          widgetState: widgetState,
                          formControlName: "day",
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                LanguageKey.requiredField.tr,
                          },
                          hintText: LanguageKey.selectDay.tr,
                          items: [
                            "monday",
                            "tuesday",
                            "wednesday",
                            "thursday",
                            "friday",
                            "saturday",
                            "sunday",
                          ]
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.tr),
                                ),
                              )
                              .toList(),
                          header: LanguageKey.day.tr,
                        ),
                        const SizedBox(height: AppDimensions.generalPadding),
                        ReactiveTimePicker(
                          initialEntryMode: TimePickerEntryMode.input,
                          formControlName: "start_time",
                          confirmText: LanguageKey.ok.tr,
                          helpText: "",
                          hourLabelText: LanguageKey.hour.tr,
                          minuteLabelText: LanguageKey.minute.tr,
                          cancelText: LanguageKey.cancel.tr,
                          builder: (context, picker, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  LanguageKey.startTime.tr,
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
                                  controller: picker.value == null
                                      ? null
                                      : TextEditingController(
                                          text: formatTimeOfDay(picker.value!),
                                        ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: AppDimensions.generalPadding),
                        ReactiveTimePicker(
                          initialEntryMode: TimePickerEntryMode.input,
                          formControlName: "end_time",
                          confirmText: LanguageKey.ok.tr,
                          cancelText: LanguageKey.cancel.tr,
                          helpText: "",
                          hourLabelText: LanguageKey.hour.tr,
                          minuteLabelText: LanguageKey.minute.tr,
                          builder: (context, picker, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  LanguageKey.endTime.tr,
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
                                  controller: picker.value == null
                                      ? null
                                      : TextEditingController(
                                          text: formatTimeOfDay(picker.value!),
                                        ),
                                ),
                              ],
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
                                if (workTime == null) {
                                  controller.addWorkTime(
                                    day: addServiceForm.value["day"] as String,
                                    endTime: formatTimeOfDay(addServiceForm
                                        .value["end_time"] as TimeOfDay),
                                    startTime: formatTimeOfDay(addServiceForm
                                        .value["start_time"] as TimeOfDay),
                                  );
                                } else {
                                  controller.updateWorkTime(
                                    workTimeId: workTime.id,
                                    day: addServiceForm.value["day"] as String,
                                    endTime: formatTimeOfDay(addServiceForm
                                        .value["end_time"] as TimeOfDay),
                                    startTime: formatTimeOfDay(addServiceForm
                                        .value["start_time"] as TimeOfDay),
                                  );
                                }
                              } else {
                                addServiceForm.markAllAsTouched();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: AppColors.primary,
                            ),
                            child: Text(
                              workTime == null
                                  ? LanguageKey.add.tr
                                  : LanguageKey.update.tr,
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

String formatTimeOfDay(TimeOfDay timeOfDay) {
  String hour = timeOfDay.hour.toString();
  String minute = timeOfDay.minute.toString();

  // Add leading zero if hour or minute is a single digit
  if (timeOfDay.hour < 10) {
    hour = '0$hour';
  }
  if (timeOfDay.minute < 10) {
    minute = '0$minute';
  }

  return '$hour:$minute';
}
