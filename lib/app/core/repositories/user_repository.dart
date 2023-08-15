import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sport/app/core/models/user_model.dart';
import 'package:sport/app/core/services/user_config.dart';

import '../constants/request_routes.dart';
import '../utils/exceptions.dart';
import 'repository_interface.dart';

class UserRepository extends RepositoryInterface {
  Future<void> checkVerificationCode({
    required String email,
    required String code,
  }) async {
    try {
      final Response response = await dio.post(
        RequestRoutes.checkActivationCode,
        data: {
          "email": email,
          "verification_code": code,
        },
      );
      await UserConfig.setUser(User.fromMap(
        response.data["user"],
        token: response.data["token"],
      ));
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String? phoneNumber,
    required String fcmToken,
    required int? gender,
    required DateTime? birthday,
    required File image,
  }) async {
    try {
      final FormData formData = FormData.fromMap({
        "name": fullName,
        "email": email,
        "phone": phoneNumber,
        "password": password,
        "firebase_token": fcmToken,
        "gender": gender,
        "browsing_mode": 'user', //stadium_manager|user
        "role": 'user', //stadium_manager|user
        "birthday": birthday?.toIso8601String(),
        "image": await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last),
      });
      await dio.post(
        RequestRoutes.register,
        data: formData,
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    try {
      final Response response = await dio.post(
        RequestRoutes.login,
        data: {
          "email": email,
          "password": password,
          "firebase_token": fcmToken,
        },
      );
      if (response.data?["user"]?["role"] == "admin") {
        throw DioException(
            message: "admin not allowed",
            response: Response(
                data: {"error": "admin not allowed"},
                requestOptions: RequestOptions(
                  data: {"error": "admin not allowed"},
                )),
            requestOptions:
                RequestOptions(data: {"error": "admin not allowed"}));
      }
      await UserConfig.setUser(User.fromMap(
        response.data["user"],
        token: response.data["token"],
      ));
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> resendVerificationCode({required String email}) async {
    try {
      await dio.post(
        RequestRoutes.resendVerificationCode,
        queryParameters: {"email": email},
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<User> getUserProfile({
    required User user,
  }) async {
    try {
      Response response = await dio.get(
        RequestRoutes.user,
      );
      User updatedUser = User.fromMap(
        response.data["user"],
        token: user.token,
        expiresInDate: user.expiresInDate,
      );
      await UserConfig.setUser(updatedUser);
      return updatedUser;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<User?> getUser() async {
    try {
      User? user = await UserConfig.getUser();

      return user;
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> deleteUser() async {
    try {
      await UserConfig.deleteUser();
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<String?> refreshToken() async {
    try {
      final Response response = await dio.post(RequestRoutes.refreshToken);
      User user = (await getUser())!;
      user = user.copyWith(
        token: response.data["token"],
        expiresInDate: DateTime.now().add(const Duration(hours: 1)),
      );
      await UserConfig.setUser(user);
      return response.data["token"];
    } catch (e) {
      if (e.runtimeType == DioException) {
        e as DioException;
        if (e.response?.statusCode == 401) {
          return null;
        }
      }
      rethrow;
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await dio.post(
        RequestRoutes.forgotPassword,
        data: {"email": email},
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<User> updateProfile({
    required String token,
    required DateTime expiresInDate,
    String? fullName,
    String? phoneNumber,
    int? gender,
    DateTime? birthday,
    File? image,
    String? browsingMode,
    String? role,
  }) async {
    try {
      Map<String, dynamic> data = {
        "name": fullName,
        "phone": phoneNumber,
        "gender": gender,
        "browsing_mode": browsingMode, //stadium_manager|user
        "role": role, //stadium_manager|user
        "birthday": birthday?.toIso8601String(),
        "image": image == null
            ? null
            : await MultipartFile.fromFile(image.path,
                filename: image.path.split('/').last),
      };
      data.removeWhere(
          (key, value) => value == null || value == "null" || value == "");
      final FormData formData = FormData.fromMap(data);
      Response response = await dio.post(
        RequestRoutes.updateProfile,
        data: formData,
      );
      User user = User.fromMap(
        response.data["user"],
        token: token,
        expiresInDate: expiresInDate,
      );
      await UserConfig.setUser(user);
      return user;
    } catch (error) {
      log(error.toString());
      throw ExceptionHandler(error);
    }
  }

  Future<void> deleteAccount({required String password}) async {
    try {
      await dio.delete(
        RequestRoutes.deleteAccount,
        data: {"password": password},
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> changeEmail({required String email}) async {
    try {
      await dio.post(
        RequestRoutes.sendUpdateEmailOTP,
        data: {"new_email": email},
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> updateEmail({
    required String email,
    required String code,
    required User user,
  }) async {
    try {
      await dio.post(
        RequestRoutes.updateEmail,
        data: {
          "new_email": email,
          "verification_code": code,
        },
      );
      await UserConfig.setUser(user.copyWith(email: email));
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }
}
