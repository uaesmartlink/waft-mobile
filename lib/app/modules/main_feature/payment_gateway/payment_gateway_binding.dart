import 'package:get/get.dart';
import 'package:sport/app/modules/main_feature/payment_gateway/payment_gateway_controller.dart';

class PaymentGatewayBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      PaymentGatewayController(),
    );
  }
}
