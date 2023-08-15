// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';

bool tester = false;
void logger(
  String message, {
  DateTime? time,
  int? sequenceNumber,
  int level = 0,
  String name = 'logger',
  Zone? zone,
  Object? error,
  StackTrace? stackTrace,
}) {
  // if (appMode == AppMode.development) {
  log(
    message,
    error: error,
    level: level,
    name: name,
    sequenceNumber: sequenceNumber,
    time: time,
    zone: zone,
    stackTrace: stackTrace,
  );
  // } else if (appMode == AppMode.test || tester) {
  print(
    '''
    name: $name
    message: $message
    ''',
  );
  // }
}
