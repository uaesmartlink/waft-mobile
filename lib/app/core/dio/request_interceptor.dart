import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sport/app/core/constants/request_routes.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/translation.dart';

import '../utils/logger.dart';
import 'dio_controller.dart';

class RequestInterceptor extends Interceptor {
  RequestInterceptor({required this.dioController});

  final DioController dioController;
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response != null) {
      logger(
        '\npath => ${err.requestOptions.path}\nmessage => ${err.response!.data}\ncode => ${err.response!.statusCode}\ntype => ${err.type}\n',
        name: "Error",
      );
      if ((err.response!.statusCode == 401 ||
              err.response!.statusCode == 403) &&
          err.requestOptions.path != RequestRoutes.refreshToken) {
        await dioController.checkToken(
          url: "shouldRefresh",
          shouldRefresh: true,
          method: "post",
        );
      }
    } else {
      logger(
        '\npath => ${err.requestOptions.path}\nmessage => ${err.message}\ncode => UnKnown\ntype => ${err.type}\n',
        name: "Error",
      );
    }
    super.onError(err, handler);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    logger(options.path, name: "RequestInterceptor");
    if (!(options.path == RequestRoutes.login && DataHelper.user == null)) {
      await dioController
          .checkToken(
            url: options.path,
            method: options.method,
          )
          .then((value) => options.headers['Authorization'] = 'Bearer $value');
    }
    options.headers["platform"] = Platform.isAndroid ? "android" : "ios";
    options.headers["Accept-Language"] = Translation.languageCode;
    logger(
      '\npath => ${options.path}\nheaders => ${options.headers}\ndata => ${options.data}\nqueryParameters => ${options.queryParameters}\n',
      name: "Request",
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.extra['isFile'] != null) {
      logger(
        '\npath => ${response.requestOptions.path}\n@statusCode => ${response.statusCode}\n@data => File\n',
        name: "Response",
      );
    } else {
      logger(
        '\npath => ${response.requestOptions.path}\nstatusCode => ${response.statusCode}\ndata => ${response.data}\n',
        name: "Response",
      );
    }

    super.onResponse(response, handler);
  }
}
