import 'globals.dart';

class ConstUrls {
  static String baseUrl() {
    if (appMode != AppMode.release) {
      return "https://api.waft.ae/api";
    } else {
      return "";
    }
  }
}
