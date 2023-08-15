import 'package:flutter/material.dart';

import '../theme/colors.dart';
import 'widget_state.dart';

class ElevatedStateButton extends StatelessWidget {
  const ElevatedStateButton({
    required this.widgetState,
    required this.onPressed,
    required this.child,
    this.color,
    this.style,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Color? color;
  final void Function()? onPressed;
  final WidgetState widgetState;
  final ButtonStyle? style;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style ?? ElevatedButton.styleFrom(backgroundColor: color),
      onPressed: widgetState == WidgetState.loading ? null : onPressed,
      child: widgetState == WidgetState.loading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: color ?? AppColors.primary,
              ))
          : child,
    );
  }
}

class OutlinedStateButton extends StatelessWidget {
  const OutlinedStateButton({
    required this.widgetState,
    required this.onPressed,
    required this.child,
    this.color,
    this.style,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Color? color;
  final void Function()? onPressed;
  final WidgetState widgetState;
  final ButtonStyle? style;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: style ??
          OutlinedButton.styleFrom(
            backgroundColor: color,
            side: const BorderSide(
              color: AppColors.secondry,
            ),
          ),
      onPressed: widgetState == WidgetState.loading ? null : onPressed,
      child: widgetState == WidgetState.loading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: color ?? AppColors.secondry,
              ))
          : child,
    );
  }
}

class TextStateButton extends StatelessWidget {
  const TextStateButton({
    required this.widgetState,
    required this.onPressed,
    required this.child,
    this.color,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Color? color;
  final void Function() onPressed;
  final WidgetState widgetState;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: color),
      onPressed: widgetState == WidgetState.loading ? null : onPressed,
      child: child,
    );
  }
}
