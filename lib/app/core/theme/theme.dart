import 'package:flutter/material.dart';

import 'colors.dart';

class CustomTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      fontFamily: "JA",
      iconTheme: const IconThemeData(color: AppColors.font),
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      splashColor: AppColors.splash,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: AppColors.font,
          size: 30,
        ),
        titleSpacing: 5,
        titleTextStyle: TextStyle(
          color: AppColors.font,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all(AppColors.primary),
          overlayColor: MaterialStateProperty.all(AppColors.font)),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(AppColors.splash),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: AppColors.font,
            displayColor: AppColors.font,
            fontFamily: "JA",
            fontSizeFactor: 1.0,
          ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondry,
        background: AppColors.background,
      ).copyWith(background: AppColors.background),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            textStyle: const TextStyle(color: AppColors.background),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.font,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.codeInput,
        filled: true,
        hintStyle: const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),

    );
  }
}
