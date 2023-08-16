import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/widgets/no_internet.dart';
import 'package:sport/app/modules/main_feature/payment_gateway/payment_gateway_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../app_constants/app_dimensions.dart';

class PaymentGatewayView extends GetView<PaymentGatewayController> {
  const PaymentGatewayView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageKey.paymentGateway.tr),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.generalPadding),
            child: GetBuilder<PaymentGatewayController>(
              id: "progress",
              builder: (controller) {
                if (controller.progress == 100) {
                  return const SizedBox();
                } else {
                  return const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
      body: GetBuilder<PaymentGatewayController>(
        id: "WebViewWidget",
        builder: (controller) {
          if (controller.error) {
            return NoInternetConnection(onRetryFunction: () {
              controller.webViewController.reload();
            });
          } else {
            return WebViewWidget(controller: controller.webViewController);
          }
        },
      ),
    );
  }
}
