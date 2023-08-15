import 'package:get/get.dart';
import 'package:sport/app/modules/auth/blocked/blocked_binding.dart';
import 'package:sport/app/modules/auth/blocked/blocked_view.dart';
import 'package:sport/app/modules/auth/check_code/check_code_binding.dart';
import 'package:sport/app/modules/auth/check_code/check_code_view.dart';
import 'package:sport/app/modules/auth/forgot_password/forgot_password_binding.dart';
import 'package:sport/app/modules/auth/forgot_password/forgot_password_view.dart';
import 'package:sport/app/modules/auth/login/login_binding.dart';
import 'package:sport/app/modules/auth/login/login_view.dart';
import 'package:sport/app/modules/auth/onboarding/onboarding_binding.dart';
import 'package:sport/app/modules/auth/onboarding/onboarding_view.dart';
import 'package:sport/app/modules/auth/pre_register/pre_register_binding.dart';
import 'package:sport/app/modules/auth/pre_register/pre_register_view.dart';
import 'package:sport/app/modules/auth/register/register_binding.dart';
import 'package:sport/app/modules/auth/register/register_view.dart';

import '../../core/utils/secure_get_page.dart';
import 'shared/constant/auth_routes.dart';
import 'wrapper/wrapper_binding.dart';
import 'wrapper/wrapper_view.dart';

part 'shared/auth_pages.dart';

class AuthModule {
  static String get authInitialRoute => AuthRoutes.wrapperRoute;
  static List<GetPage> get authPages => _AuthPages.authPages;
}
