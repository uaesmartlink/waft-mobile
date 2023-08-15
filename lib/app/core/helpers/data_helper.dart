import 'package:package_info_plus/package_info_plus.dart';
import 'package:sport/app/core/models/constants_model.dart';
import 'package:sport/app/core/models/user_model.dart';

class DataHelper {
  static late PackageInfo packageInfo;
  static Constants? constants;
  static User? user;
  static bool get logedIn => user != null;
  static void reset() {
    constants = null;
    user = null;
  }
}
