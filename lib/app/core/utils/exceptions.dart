// ignore_for_file: avoid_dynamic_calls

import 'dart:io';

import 'package:dio/dio.dart';

class CustomException implements Exception {
  CustomException._(this.error, this.message);

  final CustomError error;
  final String message;

  @override
  String toString() => "message : $error";
}

class ExceptionHandler {
  static bool checkMessage(dynamic data, String equalTo) {
    try {
      if (data != null &&
          data["message"] != null &&
          data["message"]["message"] == equalTo) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  factory ExceptionHandler(dynamic error) {
    switch (error.runtimeType) {
      case NoSuchMethodError:
        error as NoSuchMethodError;
        throw CustomException._(CustomError.formatException, error.toString());
      case HandshakeException:
        error as HandshakeException;
        throw CustomException._(CustomError.unauthorized, error.toString());
      case FormatException:
        error as FormatException;
        throw CustomException._(CustomError.formatException, error.toString());
      case TypeError:
        error as TypeError;
        throw CustomException._(CustomError.formatException, error.toString());
      case DioException:
        error as DioException;
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.message == null ||
            (error.message!.contains("SocketException"))) {
          throw CustomException._(CustomError.noInternet, error.toString());
        } else if (error.type == DioExceptionType.cancel &&
            error.error == "cancel by next request") {
          throw CustomException._(
              CustomError.cancelByNextRequest, "cancel by next request");
        } else {
          dynamic data = error.response?.data;
          if (data.runtimeType == String) {
            throw CustomException._(CustomError.unKnown, error.toString());
          }
          Map<String, dynamic>? errors = error.response?.data?["errors"];
          if (errors != null) {
            if (errors["email"] != null) {
              throw CustomException._(
                  CustomError.badRequest, errors["email"][0]);
            } else if (errors["phone"] != null) {
              throw CustomException._(
                  CustomError.badRequest, errors["phone"][0]);
            } else if (errors["new_email"] != null) {
              throw CustomException._(
                  CustomError.badRequest, errors["new_email"][0]);
            }
          } else if (error.response?.data?["error"] == "Email not verified.") {
            throw CustomException._(
                CustomError.emailNotVerified, error.toString());
          } else if (error.response?.data?["error"] ==
              "Invalid verification code.") {
            throw CustomException._(CustomError.wrongCode, error.toString());
          } else if (error.response?.data?["error"] ==
              "Email address not found.") {
            throw CustomException._(
                CustomError.emailNotFound, error.toString());
          } else if (error.response?.data?["error"] == "admin not allowed") {
            throw CustomException._(
                CustomError.adminNotAllowed, error.toString());
          } else if (error.response?.data?["error"] ==
              "Too many password reset requests. Please try again later.") {
            throw CustomException._(
                CustomError.tryAgainLater, error.toString());
          } else {
            throw CustomException._(CustomError.unKnown, error.toString());
          }
        }
        throw CustomException._(CustomError.unKnown, error.toString());
      case SocketException:
        error as SocketException;
        throw CustomException._(CustomError.noInternet, error.toString());
      case HttpException:
        error as HttpException;
        throw CustomException._(CustomError.noInternet, error.toString());
      default:
        throw CustomException._(CustomError.unKnown, error.toString());
    }
  }
}

enum CustomError {
  noInternet,
  conflict,
  unKnown,
  wrongCode,
  emailNotVerified,
  alreadyExists,
  notFound,
  formatException,
  badRequest,
  unauthorized,
  cancelByNextRequest,
  emailNotFound,
  tryAgainLater,
  adminNotAllowed,
}
