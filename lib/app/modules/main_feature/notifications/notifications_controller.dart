import 'package:sport/app/core/models/notification_model.dart';
import 'package:sport/app/core/repositories/activities_repository.dart';
import 'package:sport/app/core/services/data_list_mixin.dart';
import 'package:sport/app/core/services/request_mixin.dart';

import '../../../core/services/getx_state_controller.dart';

class NotificationsController extends GetxStateController
    with DataList<NotificationModel> {
  NotificationsController({
    required this.activitiesRepository,
  });
  final ActivitiesRepository activitiesRepository;

  Future<void> getNotifications(
      [RequestType requestType = RequestType.getData]) async {
    await handelDataList(
      ids: ["getNotifications"],
      requestType: requestType,
      function: () async {
        return await activitiesRepository.getNotifications(page: page);
      },
    );
  }

  @override
  void onInit() {
    getNotifications();
    super.onInit();
  }
}
