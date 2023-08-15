import 'package:dio/dio.dart';
import 'package:sport/app/core/repositories/user_repository.dart';

import '../constants/urls.dart';
import 'dio_controller.dart';
import 'request_interceptor.dart';

class DioFactory {
  static Dio dioSetUp({required UserRepository userRepository}) {
    final BaseOptions options = BaseOptions(
      baseUrl: ConstUrls.baseUrl(),
      sendTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      contentType: "application/json",
    );
    final Dio dio = Dio(options);
    dio.interceptors.addAll([
      RequestInterceptor(
        dioController: DioController(
          dio: dio,
          userRepository: userRepository,
        ),
      ),
    ]);
    return dio;
  }
}
