import 'package:get/get.dart';
import 'package:sport/app/modules/main_feature/add_activity/add_activity_binding.dart';
import 'package:sport/app/modules/main_feature/add_activity/add_activity_view.dart';
import 'package:sport/app/modules/main_feature/booking_result/booking_result_binding.dart';
import 'package:sport/app/modules/main_feature/booking_result/booking_result_view.dart';
import 'package:sport/app/modules/main_feature/change_email/change_email_binding.dart';
import 'package:sport/app/modules/main_feature/change_email/change_email_view.dart';
import 'package:sport/app/modules/main_feature/edit_profile/edit_profile_binding.dart';
import 'package:sport/app/modules/main_feature/edit_profile/edit_profile_view.dart';
import 'package:sport/app/modules/main_feature/language/language_binding.dart';
import 'package:sport/app/modules/main_feature/language/language_view.dart';
import 'package:sport/app/modules/main_feature/notifications/notifications_binding.dart';
import 'package:sport/app/modules/main_feature/notifications/notifications_view.dart';
import 'package:sport/app/modules/main_feature/payment_gateway/payment_gateway_binding.dart';
import 'package:sport/app/modules/main_feature/payment_gateway/payment_gateway_view.dart';
import 'package:sport/app/modules/main_feature/payment_history/payment_history_binding.dart';
import 'package:sport/app/modules/main_feature/payment_history/payment_history_view.dart';
import 'package:sport/app/modules/main_feature/review_summary/review_summary_binding.dart';
import 'package:sport/app/modules/main_feature/review_summary/review_summary_view.dart';

import '../../core/utils/secure_get_page.dart';
import 'activity_details/activity_details_binding.dart';
import 'activity_details/activity_details_view.dart';
import 'book_appointment/book_appointment_binding.dart';
import 'book_appointment/book_appointment_view.dart';
import 'favorites/favorites_binding.dart';
import 'favorites/favorites_view.dart';
import 'home_structuring/home_structuring_binding.dart';
import 'home_structuring/home_structuring_view.dart';
import 'search_activities/search_activities_binding.dart';
import 'search_activities/search_activities_view.dart';
import 'shared/constant/home_routes.dart';

part 'shared/home_pages.dart';

class HomeModule {
  static String get homeInitialRoute => HomeRoutes.homeStructuringRoute;
  static List<GetPage> get homePages => _HomePages.homePages;
}
