import 'dart:math';

import 'package:flutter/material.dart';

class CustomSize {
  CustomSize({
    required double constWidth,
    required double constHeight,
    required double screenWidth,
    required double screenHeight,
  }) {
    _cureentScreenHeight = screenHeight - constHeight;
    _cureentScreenWidth = screenWidth - constWidth;
  }

  late double _cureentScreenHeight;
  late double _cureentScreenWidth;

  double get screenHeight => _cureentScreenHeight;
  double get screenWidth => _cureentScreenWidth;

  double setHeight(double inputHeight) {
    if (((inputHeight / 843) * _cureentScreenHeight) < 1) {
      return 1;
    } else {
      return (inputHeight / 843) * _cureentScreenHeight;
    }
  }

  double textScaleFactor({double maxTextScaleFactor = 2}) {
    double val = (_cureentScreenWidth / 411) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }

  double setRadius(double inputRadius) {
    final double width = (inputRadius / 411) * _cureentScreenWidth;
    final double height = (inputRadius / 843) * _cureentScreenHeight;
    return min(height, width);
  }

  double setWidth(double inputWidth) {
    if (((inputWidth / 411) * _cureentScreenWidth) < 1) {
      return 1;
    } else {
      return (inputWidth / 411) * _cureentScreenWidth;
    }
  }
}

typedef Sizer = Widget Function(CustomSize customSize);

class ScreenSizer extends StatelessWidget {
  const ScreenSizer({
    required this.builder,
    this.context,
    this.constWidth = 0.0,
    this.constHeight = 0.0,
    Key? key,
  }) : super(key: key);

  final Sizer builder;
  final double constHeight;
  final double constWidth;
  final BuildContext? context;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final CustomSize customSize = CustomSize(
        constHeight: constHeight,
        screenHeight: constraints.maxHeight,
        screenWidth: constraints.maxWidth,
        constWidth: constWidth,
      );
      return builder(customSize);
    });
  }
}
