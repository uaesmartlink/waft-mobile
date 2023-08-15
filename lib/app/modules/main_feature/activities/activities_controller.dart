import 'package:sport/app/core/models/activity_type_model.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/core/services/data_list_mixin.dart';
import 'package:sport/app/core/services/request_mixin.dart';

import '../../../core/services/getx_state_controller.dart';

class ActivitiesController extends GetxStateController
    with DataList<ActivityType> {
  ActivitiesController({
    required this.constantsRepository,
  });
  final ConstantsRepository constantsRepository;

  Future<void> getActivityTypes(
      [RequestType requestType = RequestType.getData]) async {
    await handelDataList(
      ids: ["getActivityTypes"],
      requestType: requestType,
      function: () async {
        return await constantsRepository.getActivityTypes();
      },
    );
  }

  @override
  void onInit() {
    getActivityTypes();
    super.onInit();
  }
}
