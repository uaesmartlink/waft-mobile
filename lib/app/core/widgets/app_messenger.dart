import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/theme/colors.dart';

import '../constants/globals.dart';
import '../utils/exceptions.dart';

class CustomToast {
  CustomToast.showDefault(String message, [bool showToast = false]) {
    BotToast.closeAllLoading();
    if (showToast) {
      BotToast.showText(text: message);
    } else {
      AppMessenger.message(message);
    }
  }

  CustomToast.showError(CustomException error, [bool showToast = false]) {
    BotToast.closeAllLoading();
    String message = '';
    switch (error.error) {
      case CustomError.badRequest:
        message = error.message.tr;
        break;

      case CustomError.wrongCode:
        message = LanguageKey.invalidVerificationCode.tr;
        break;
      case CustomError.emailNotFound:
        message = LanguageKey.emailNotFound.tr;
        break;

      case CustomError.unKnown:
        message = LanguageKey.checkConnection.tr;
        break;
      case CustomError.tryAgainLater:
        message = LanguageKey.tryAgainLater.tr;
        break;
      case CustomError.adminNotAllowed:
        message = LanguageKey.adminNotAllowed.tr;
        break;

      default:
        message = LanguageKey.checkConnection.tr;
    }
    if (showToast) {
      BotToast.showText(text: message, contentColor: AppColors.red);
    } else {
      AppMessenger.error(message);
    }
  }
}

class AppMessenger {
  void showSnackBar(
      {required Widget content,
      SnackBarAction? action,
      Color? backgroundColor,
      Duration duration = const Duration(milliseconds: 4000)}) {
    final ScaffoldMessengerState? currentState = snackbarKey.currentState;
    if (currentState != null) {
      currentState
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
          content: content,
          backgroundColor: backgroundColor ?? AppColors.backgroundTextFilled,
          action: action,
          dismissDirection: DismissDirection.none,
          duration: duration,
        ));
    }
  }

  AppMessenger.error(String message) {
    BotToast.showText(
      text: message,
      contentColor: AppColors.red,
      textStyle: const TextStyle(
        fontSize: 16,
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.bold,
        color: AppColors.background,
      ),
    );
  }
  AppMessenger.message(String message) {
    BotToast.showText(
      text: message,
      contentColor: AppColors.backgroundTextFilled,
      textStyle: const TextStyle(
        fontSize: 16,
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.bold,
        color: AppColors.background,
      ),
    );
  }
  AppMessenger.warning(String message) {
    BotToast.showText(
      text: message,
      contentColor: AppColors.secondry,
      textStyle: const TextStyle(
        fontSize: 16,
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.bold,
        color: AppColors.font,
      ),
    );
  }
}
