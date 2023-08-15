import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';
import 'package:sport/app/core/widgets/elevated_button.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/main_feature/add_activity/widgets/first_form.dart';
import 'package:sport/app/modules/main_feature/add_activity/widgets/second_form.dart';
import 'package:sport/app/modules/main_feature/add_activity/widgets/third_form.dart';

import 'add_activity_controller.dart';

class AddActivityView extends GetView<AddActivityController> {
  const AddActivityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateBuilder<AddActivityController>(
      id: "addActivity",
      disableState: true,
      initialWidgetState: WidgetState.loaded,
      builder: (widgetState, controller) {
        return WillPopScope(
          onWillPop: () async {
            if (controller.pageIndex != 0) {
              FocusScope.of(context).unfocus();
              controller.changePage(controller.pageIndex - 1);
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size(double.infinity, 100),
              child: AppBar(
                toolbarHeight: 100,
                title: Text(
                  controller.activity != null
                      ? LanguageKey.updateActivity.tr
                      : LanguageKey.addNewActivity.tr,
                ),
                leading: InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    if (controller.pageIndex != 0) {
                      controller.changePage(controller.pageIndex - 1);
                    } else {
                      Get.back();
                    }
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.font,
                  ),
                ),
              ),
            ),
            floatingActionButton: controller.pageIndex != 2
                ? SizedBox(
                    width: 65,
                    height: 65,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (controller.pageIndex == 0) {
                          if (controller.firstAddActivityForm.valid) {
                            if (controller.activityImage == null &&
                                controller.activity == null) {
                              AppMessenger.message(
                                  LanguageKey.chooseActivityPhoto.tr);
                              return;
                            }
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            controller.changePage(1);
                          } else {
                            controller.firstAddActivityForm.markAllAsTouched();
                          }
                        } else if (controller.pageIndex == 1) {
                          if (controller.secondAddActivityForm.valid) {
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            controller.changePage(2);
                          } else {
                            controller.secondAddActivityForm.markAllAsTouched();
                          }
                        }
                      },
                      child: const Icon(
                        Icons.navigate_next_rounded,
                        size: 50,
                      ),
                    ),
                  )
                : SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 40,
                    child: ElevatedStateButton(
                      widgetState: widgetState,
                      onPressed: () {
                        if (controller.thirdAddActivityForm.valid) {
                          FocusScope.of(context).unfocus();
                          String processedPhoneNumber = controller
                              .firstAddActivityForm.value["phone"] as String;

                          processedPhoneNumber =
                              '+971${processedPhoneNumber.startsWith('0') ? processedPhoneNumber.substring(1) : processedPhoneNumber}';

                          if (controller.activity == null) {
                            controller.addActivity(
                              nameEn: controller.thirdAddActivityForm
                                  .value["name_en"] as String,
                              nameAr: controller.secondAddActivityForm
                                  .value["name_ar"] as String,
                              regionId: controller.firstAddActivityForm
                                  .value["region_id"] as int,
                              activityId: controller.firstAddActivityForm
                                  .value["activity_id"] as int,
                              mapUrl: controller.firstAddActivityForm
                                  .value["map_url"] as String,
                              descriptionEn: controller.thirdAddActivityForm
                                  .value["description_en"] as String,
                              descriptionAr: controller.secondAddActivityForm
                                  .value["description_ar"] as String,
                              addressAr: controller.secondAddActivityForm
                                  .value["address_ar"] as String,
                              addressEn: controller.thirdAddActivityForm
                                  .value["address_en"] as String,
                              phone: processedPhoneNumber,
                              email: controller.firstAddActivityForm
                                  .value["email"] as String,
                              website: controller.firstAddActivityForm
                                  .value["website"] as String,
                            );
                          } else {
                            controller.updateActivity(
                              nameEn: controller.thirdAddActivityForm
                                  .value["name_en"] as String,
                              nameAr: controller.secondAddActivityForm
                                  .value["name_ar"] as String,
                              regionId: controller.firstAddActivityForm
                                  .value["region_id"] as int,
                              activityId: controller.firstAddActivityForm
                                  .value["activity_id"] as int,
                              mapUrl: controller.firstAddActivityForm
                                  .value["map_url"] as String,
                              descriptionEn: controller.thirdAddActivityForm
                                  .value["description_en"] as String,
                              descriptionAr: controller.secondAddActivityForm
                                  .value["description_ar"] as String,
                              addressAr: controller.secondAddActivityForm
                                  .value["address_ar"] as String,
                              addressEn: controller.thirdAddActivityForm
                                  .value["address_en"] as String,
                              phone: processedPhoneNumber,
                              email: controller.firstAddActivityForm
                                  .value["email"] as String,
                              website: controller.firstAddActivityForm
                                  .value["website"] as String,
                            );
                          }
                        } else {
                          controller.thirdAddActivityForm.markAllAsTouched();
                        }
                      },
                      child: Text(
                        controller.activity == null
                            ? LanguageKey.add.tr
                            : LanguageKey.update.tr,
                        style: const TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
            body: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                FirstFormAddActivity(
                  widgetState: widgetState,
                  formGroup: controller.firstAddActivityForm,
                ),
                SecondFormAddActivity(
                  widgetState: widgetState,
                  formGroup: controller.secondAddActivityForm,
                ),
                ThirdFormAddActivity(
                  widgetState: widgetState,
                  formGroup: controller.thirdAddActivityForm,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
