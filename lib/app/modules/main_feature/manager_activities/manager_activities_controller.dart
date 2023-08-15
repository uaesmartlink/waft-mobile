import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/services/data_list_mixin.dart';
import 'package:sport/app/core/services/request_mixin.dart';

import '../../../core/services/getx_state_controller.dart';

class ManagerActivitiesController extends GetxStateController
    with DataList<Activity> {
  ManagerActivitiesController({
    required this.activitiesRepository,
  });
  final ActivitiesRepository activitiesRepository;

  Future<void> getManagerActivity(
      [RequestType requestType = RequestType.getData]) async {
    await handelDataList(
      ids: ["getManagerActivity"],
      requestType: requestType,
      function: () async {
        return await activitiesRepository.getManagerActivity();
      },
    );
  }

  @override
  void onInit() {
    getManagerActivity();
    super.onInit();
  }
}
