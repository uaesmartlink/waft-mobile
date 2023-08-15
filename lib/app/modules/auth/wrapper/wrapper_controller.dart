import 'package:get/get.dart';
import 'package:sport/app/core/dio/dio_controller.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/models/constants_model.dart';
import 'package:sport/app/core/repositories/user_repository.dart';
import 'package:sport/app/core/services/notifications/firebase_cloud_messaging.dart';
import 'package:sport/app/core/services/user_config.dart';
import 'package:sport/app/core/widgets/widget_state.dart';
import 'package:sport/app/modules/auth/shared/constant/auth_routes.dart';
import 'package:sport/app/modules/auth/wrapper/wrapper_view.dart';
import 'package:sport/app/modules/main_feature/home_module.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/repositories/constants_repository.dart';
import '../../../core/services/getx_state_controller.dart';

class WrapperController extends GetxStateController {
  WrapperController({
    required this.constantsRepository,
    required this.userRepository,
    required this.dioController,
  });

  final ConstantsRepository constantsRepository;
  final UserRepository userRepository;
  final DioController dioController;
  bool isUpdateBottomSheetOpen = false;
  bool showOnBoarding = false;
  @override
  void onInit() async {
    await initWrapper();
    super.onInit();
  }

  Future<void> initWrapper() async {
    try {
      NotificationService.instance.initializeNotifications();
      updateState(["WrapperView"], WidgetState.loading);
      DataHelper.reset();
      DataHelper.user = await userRepository.getUser();
      await dioController.checkToken(
        url: "shouldRefresh",
        shouldRefresh: true,
        method: "post",
      );
      if ((await UserConfig.getConstants()) == null) {
        showOnBoarding = true;
      }
      DataHelper.constants = await constantsRepository.getConstants(
        onUpdate: (constants) {
          DataHelper.constants = constants;
        },
      );
      if (DataHelper.user != null) {
        userRepository.getUserProfile(user: DataHelper.user!).then((value) {
          DataHelper.user = value;
        });
      }
      await checkAppUpdate();
    } catch (e) {
      updateState(["WrapperView"], WidgetState.error);
    }
  }

  Future<void> checkAppUpdate() async {
    try {
      final AppVersion appVersion = DataHelper.constants!.appVersion;
      if ((appVersion.showUpdate &&
                  (appVersion.latestVersionCode >
                      (int.tryParse(DataHelper.packageInfo.buildNumber) ??
                          1)) ||
              appVersion.forceUpdate) &&
          !isUpdateBottomSheetOpen) {
        appUpdateBottomSheet(
          appVersion: appVersion,
          onUpdate: () {
            launchUrl(Uri.parse(DataHelper.constants!.appVersion.storeLink),
                mode: LaunchMode.externalApplication);
          },
          onIgnore: () async {
            isUpdateBottomSheetOpen = false;
            DataHelper.constants!.appVersion.ignore();
            await UserConfig.setConstants(DataHelper.constants!);
            Get.back();
            if (showOnBoarding) {
              await Get.offAndToNamed(AuthRoutes.onBoardingRoute);
            } else {
              await Get.offAndToNamed(HomeModule.homeInitialRoute);
            }
          },
        );
      } else {
        if (showOnBoarding) {
          await Get.offAndToNamed(AuthRoutes.onBoardingRoute);
        } else {
          await Get.offAndToNamed(HomeModule.homeInitialRoute);
        }
      }
    } catch (_) {
      rethrow;
    }
  }
}
