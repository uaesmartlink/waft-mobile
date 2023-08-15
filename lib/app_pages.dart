import 'package:get/get.dart';
import 'package:sport/app/modules/auth/auth_module.dart';
import 'package:sport/app/modules/main_feature/home_module.dart';

class AppPages {
  AppPages._();
  static final List<GetPage<dynamic>> appRoutes = [
    ...AuthModule.authPages,
    ...HomeModule.homePages,
  ];
}
