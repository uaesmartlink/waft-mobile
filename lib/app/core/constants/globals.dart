import 'package:flutter/material.dart';

AppMode appMode = AppMode.development;

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

enum AppMode { development, test, release, local }
