import 'package:sport/app/core/models/transaction_model.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/services/data_list_mixin.dart';
import 'package:sport/app/core/services/request_mixin.dart';

import '../../../core/services/getx_state_controller.dart';

class PaymentHistoryController extends GetxStateController
    with DataList<Transaction> {
  PaymentHistoryController({
    required this.activitiesRepository,
  });
  final ActivitiesRepository activitiesRepository;

  Future<void> getPaymentHistory(
      [RequestType requestType = RequestType.getData]) async {
    await handelDataList(
      ids: ["getPaymentHistory"],
      requestType: requestType,
      function: () async {
        return await activitiesRepository.getPaymentHistory(page: page);
      },
    );
  }

  @override
  void onInit() {
    getPaymentHistory();
    super.onInit();
  }
}
