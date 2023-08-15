import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport/app/core/models/constants_model.dart';
import 'package:sport/app/core/models/user_model.dart';
import 'package:sport/app/core/utils/logger.dart';

class UserConfig {
  static Future<void> setUser(User user) async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString("user", jsonEncode(user.toMap()));
    } catch (e) {
      logger(e.toString());
    }
  }

  static Future<void> deleteUser() async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.remove("user");
    } catch (e) {
      logger(e.toString());
    }
  }

  static Future<User?> getUser() async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.reload();
      final String? encodedUser = sharedPreferences.getString("user");
      if (encodedUser != null) {
        return User.fromMap(jsonDecode(encodedUser));
      } else {
        return null;
      }
    } catch (e) {
      logger(e.toString());
      return null;
    }
  }

  static Future<void> setLanguageCode(String languageCode) async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString("languageCode", languageCode);
    } catch (e) {
      logger(e.toString());
    }
  }

  static Future<String?> getLanguageCode() async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.reload();
      final String? languageCode = sharedPreferences.getString("languageCode");
      return languageCode;
    } catch (e) {
      logger(e.toString());
      return null;
    }
  }

  static Future<void> setConstants(Constants constants) async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString(
          "constants", jsonEncode(constants.toMap()));
    } catch (e) {
      logger(e.toString());
    }
  }

  static Future<Constants?> getConstants() async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.reload();
      final String? encodedConstants = sharedPreferences.getString("constants");
      if (encodedConstants != null) {
        return Constants.fromMap(jsonDecode(encodedConstants));
      } else {
        return null;
      }
    } catch (e) {
      logger(e.toString());
      return null;
    }
  }
}
