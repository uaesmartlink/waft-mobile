import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/user_model.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';
import 'package:sport/app/core/widgets/elevated_button.dart';
import 'package:sport/app/core/widgets/go_login.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/auth/shared/constant/auth_routes.dart';
import 'package:sport/app/modules/main_feature/shared/constant/home_routes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app_constants/app_assets.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: Image.asset(
            AppAssets.logo,
          ),
        ),
        title: Text(
          LanguageKey.profile.tr,
        ),
      ),
      body: GetBuilder<ProfileController>(
          id: "Profile",
          builder: (controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  if (DataHelper.logedIn) ...[
                    SizedBox(
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 75,
                            backgroundColor: AppColors.codeInput,
                            backgroundImage: CachedNetworkImageProvider(
                              DataHelper.user?.image ?? "",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      DataHelper.user?.name ?? "",
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DataHelper.user?.email ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(endIndent: 30, indent: 30),
                    const SizedBox(height: 5),
                  ],
                  item(
                    assetName: AppAssets.star,
                    title: DataHelper.user?.role == AccountType.manager
                        ? DataHelper.user?.browsingType == AccountType.user
                            ? LanguageKey.backToPartnerMode.tr
                            : LanguageKey.browseAsUser.tr
                        : LanguageKey.beWaftPartner.tr,
                    color: AppColors.primary,
                    onTap: () {
                      if (DataHelper.logedIn) {
                        if (DataHelper.user!.role == AccountType.user) {
                          partnerDialog(context: context);
                        } else {
                          controller.updateProfile(
                              browsingMode: DataHelper.user!.browsingType ==
                                      AccountType.user
                                  ? "stadium_manager"
                                  : "user");
                        }
                      } else {
                        loginBottomSheet(
                            description: LanguageKey.loginToBeWaftPartner.tr);
                      }
                    },
                  ),
                  if (DataHelper.logedIn) ...[
                    item(
                      assetName: AppAssets.profile,
                      title: LanguageKey.editProfile.tr,
                      route: HomeRoutes.editProfileRoute,
                    ),
                    item(
                      assetName: AppAssets.notifications,
                      title: LanguageKey.notifications.tr,
                      route: HomeRoutes.notificationsRoute,
                    ),
                    if (DataHelper.user!.browsingType == AccountType.user)
                      item(
                        assetName: AppAssets.payment,
                        title: LanguageKey.paymentHistory.tr,
                        route: HomeRoutes.paymentHistoryRoute,
                      ),
                  ],
                  item(
                    assetName: AppAssets.language,
                    title: LanguageKey.language.tr,
                    route: HomeRoutes.languageRoute,
                  ),
                  item(
                    assetName: AppAssets.privacyPolicy,
                    title: LanguageKey.privacyPolicy.tr,
                    onTap: () async {
                      launchUrl(
                        Uri.parse(DataHelper.constants?.privacyPolicy ?? ""),
                        mode: LaunchMode.inAppWebView,
                      );
                    },
                  ),
                  item(
                    assetName: AppAssets.shieldDone,
                    title: LanguageKey.termsOfUse.tr,
                    onTap: () async {
                      launchUrl(
                        Uri.parse(
                            DataHelper.constants?.termsAndConditions ?? ""),
                        mode: LaunchMode.inAppWebView,
                      );
                    },
                  ),
                  item(
                    assetName: AppAssets.dangerCircle,
                    title: LanguageKey.aboutUs.tr,
                    onTap: () async {
                      launchUrl(
                        Uri.parse(DataHelper.constants?.aboutUs ?? ""),
                        mode: LaunchMode.inAppWebView,
                      );
                    },
                  ),
                  item(
                    assetName: AppAssets.share,
                    title: LanguageKey.shareApp.tr,
                    onTap: () {
                      Share.share(
                          "${LanguageKey.sharingIsCaring.tr}\n\nPlay Store:\n${DataHelper.constants?.appVersionAndroid.storeLink}\n\nApp Store:\n${DataHelper.constants?.appVersionIos.storeLink}");
                    },
                  ),
                  if (DataHelper.logedIn) ...[
                    item(
                      assetName: AppAssets.logout,
                      title: LanguageKey.logout.tr,
                      color: AppColors.red,
                      onTap: () {
                        logOutDialog(
                          context: context,
                          onConfirm: controller.logout,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextButton(
                        onPressed: () {
                          deleteAccountDialog(
                            context: context,
                          );
                        },
                        child: Text(
                          LanguageKey.deleteAccount.tr,
                          style: const TextStyle(
                            color: AppColors.red,
                          ),
                        ),
                      ),
                    ),
                  ] else
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(AuthRoutes.loginRoute);
                          },
                          child: Text(LanguageKey.signIn.tr),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
    );
  }

  Widget item({
    required String assetName,
    required String title,
    String? route,
    void Function()? onTap,
    Color color = AppColors.font,
  }) {
    return InkWell(
      onTap: onTap ??
          () {
            if (route != null) {
              Get.toNamed(route);
            }
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Row(
          children: [
            SvgPicture.asset(
              assetName,
              width: 25,
              height: 25,
              color: color,
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: color,
            )
          ],
        ),
      ),
    );
  }

  void logOutDialog({
    required BuildContext context,
    required Function onConfirm,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.background,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width - 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LanguageKey.logout.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 5),
                  child: Text(LanguageKey.sureLogout.tr),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      width: (MediaQuery.of(context).size.width - 150) * 0.5,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: AppColors.red),
                          onPressed: () {
                            Get.back();
                            onConfirm();
                            FocusScope.of(context).unfocus();
                          },
                          child: Text(LanguageKey.logout.tr)),
                    ),
                    SizedBox(
                      height: 50,
                      width: (MediaQuery.of(context).size.width - 150) * 0.5,
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: AppColors.primary),
                        child: Text(LanguageKey.back.tr),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void deleteAccountDialog({
    required BuildContext context,
  }) {
    TextEditingController textEditingController = TextEditingController();
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
              child: StateBuilder<ProfileController>(
                  id: "deleteAccount",
                  disableState: true,
                  initialWidgetState: WidgetState.loaded,
                  builder: (widgetState, controller) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          LanguageKey.deleteAccount.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          LanguageKey.sureDeleteAccount.tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.red,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          onTap: () {
                            if (textEditingController.selection.extent.offset ==
                                0) {
                              textEditingController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset:
                                          textEditingController.text.length));
                              controller.update(["addReview"]);
                            }
                          },
                          obscureText: true,
                          readOnly: widgetState == WidgetState.loading,
                          controller: textEditingController,
                          maxLength: 50,
                          decoration: InputDecoration(
                            hintText: LanguageKey.enterPassword.tr,
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            counter: const SizedBox(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedStateButton(
                            widgetState: widgetState,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (textEditingController.text == "") {
                                AppMessenger.message(
                                    LanguageKey.passwordRequired.tr);
                                return;
                              }
                              controller.deleteAccount(
                                password: textEditingController.text,
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

void partnerDialog({
  required BuildContext context,
}) {
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
            child: StateBuilder<ProfileController>(
                id: "partnerDialog",
                disableState: true,
                initialWidgetState: WidgetState.loaded,
                builder: (widgetState, controller) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        LanguageKey.beWaftPartner.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        LanguageKey.beWaftPartnerDescription.tr,
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
                            FocusScope.of(context).unfocus();
                            controller.updateProfile(
                              browsingMode: "stadium_manager",
                              role: "stadium_manager",
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            backgroundColor: AppColors.primary,
                          ),
                          child: Text(
                            LanguageKey.continueKye.tr,
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
