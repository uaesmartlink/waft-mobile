import 'package:get/get.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/models/package_model.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/utils/logger.dart';
import 'package:sport/app/modules/main_feature/shared/constant/home_routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/services/getx_state_controller.dart';

class PaymentGatewayController extends GetxStateController {
  late final WebViewController webViewController;
  late final String paymentGatewayUrl;
  late final Activity activity;
  late final Package package;
  late final DateTime date;
  int progress = 0;
  bool error = false;
  @override
  void onInit() {
    activity = Get.arguments["activity"];
    date = Get.arguments["date"];
    package = Get.arguments["selectedPackage"];
    paymentGatewayUrl = Get.parameters["paymentGatewayUrl"] ?? "";
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.background)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) {
            error = false;
            logger(change.url.toString(), name: "onUrlChange");
            update(["WebViewWidget"]);
            String path = "https://waft.ae/bookingResult";

            print("==========Change==============");
            print(change.url);
            // print(change.url != null && change.url!.contains(path));
            print("==============================");

            if (change.url != null &&
                change.url!.contains(path)) {
              print("##################");
              Get.offAndToNamed(
                HomeRoutes.bookingResultRoute,
                arguments: {
                  "activity": activity,
                  "date": date,
                  "selectedPackage": package,
                  "paymentResultUrl": change.url,
                },
              );
            }
          },
          onWebResourceError: (error) async {
            await Future.delayed(const Duration(seconds: 2));
            update(["WebViewWidget"]);
            this.error = true;
            logger(error.toString(), name: "onWebResourceError");
          },
          onProgress: (int progress) {
            error = false;
            this.progress = progress;
            update(["progress", "WebViewWidget"]);
            logger(progress.toString(), name: "onProgress");
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentGatewayUrl));
    super.onInit();
  }
}
