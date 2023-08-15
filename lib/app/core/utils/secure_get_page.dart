import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../modules/auth/shared/constant/auth_routes.dart';
import '../helpers/data_helper.dart';

class SecureGetPage<T> extends GetPage<T> {
  SecureGetPage({
    required super.name,
    required super.page,
    super.binding,
    List<GetMiddleware>? middlewares,
    super.transition,
  }) : super(
          middlewares: middlewares != null
              ? [...middlewares]
              : [
                  // EnsureLogedin(),
                  EnsureActivated(),
                ],
        );
}

class EnsureLogedin extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (route != AuthRoutes.wrapperRoute &&
        route != AuthRoutes.loginRoute &&
        route != AuthRoutes.checkCodeRoute &&
        route != AuthRoutes.onBoardingRoute &&
        route != AuthRoutes.forgotPasswordRoute &&
        route != AuthRoutes.registerRoute &&
        route != AuthRoutes.blockedRoute &&
        DataHelper.user == null) {
      return const RouteSettings(name: AuthRoutes.onBoardingRoute);
    } else {
      return null;
    }
  }
}

class EnsureActivated extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (route != AuthRoutes.wrapperRoute &&
        route != AuthRoutes.loginRoute &&
        route != AuthRoutes.forgotPasswordRoute &&
        route != AuthRoutes.checkCodeRoute &&
        route != AuthRoutes.onBoardingRoute &&
        route != AuthRoutes.registerRoute &&
        route != AuthRoutes.blockedRoute &&
        DataHelper.user != null &&
        DataHelper.user!.blocked) {
      return const RouteSettings(name: AuthRoutes.blockedRoute);
    } else {
      return null;
    }
  }
}
