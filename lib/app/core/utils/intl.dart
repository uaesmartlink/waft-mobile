import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

TextDirection getTextDirection(String text) {
  return intl.Bidi.startsWithRtl(text) ? TextDirection.rtl : TextDirection.ltr;
}

String dateFormat(DateTime dateTime, [bool inDetails = false]) {
  final DateTime localeDateTime = dateTime.toLocal();
  if (!inDetails) {
    if (localeDateTime.year != DateTime.now().year) {
      return intl.DateFormat('yyyy-MM-dd').format(localeDateTime);
    } else {
      if (localeDateTime.month != DateTime.now().month) {
        return intl.DateFormat.MMMMd().format(localeDateTime);
      } else {
        if (DateTime.now().day != localeDateTime.day) {
          final int day = DateTime.now().day - localeDateTime.day;
          return "${day > 0 ? day : 0} ي";
        } else {
          if (DateTime.now().hour != localeDateTime.hour) {
            final int hour = DateTime.now().hour - localeDateTime.hour;
            return "${hour > 0 ? hour : 0} س";
          } else {
            if (DateTime.now().minute != localeDateTime.minute) {
              final int min = DateTime.now().minute - localeDateTime.minute;
              return "${min > 0 ? min : 0} د";
            } else {
              final int sec = DateTime.now().second - localeDateTime.second;
              return "${sec > 0 ? sec : 0} ثا";
            }
          }
        }
      }
    }
  } else {
    return intl.DateFormat.yMMMMd('en').format(localeDateTime);
  }
}

extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    if (weekday == 4) {
      return add(const Duration());
    } else {
      return add(
        Duration(
          days: (day - weekday) % DateTime.daysPerWeek,
        ),
      );
    }
  }

  DateTime previous(int day) {
    if (weekday == 5) {
      return subtract(const Duration());
    } else {
      return subtract(
        Duration(
          days: (weekday - day) % DateTime.daysPerWeek,
        ),
      );
    }
  }

  bool sameDay([DateTime? date]) {
    DateTime currentDate = date ?? DateTime.now();
    return day == currentDate.day &&
        month == currentDate.month &&
        year == currentDate.year;
  }

  bool sameMonth() {
    DateTime currentDate = DateTime.now();
    return month == currentDate.month && year == currentDate.year;
  }

  bool sameYear() {
    DateTime currentDate = DateTime.now();
    return year == currentDate.year;
  }
}

String getTimeStringFromDouble(double value) {
  if (value < 0) return '00:00';
  final int flooredValue = value.floor();
  final double decimalValue = value - flooredValue;
  final String hourValue = getHourString(flooredValue);
  final String minuteString = getMinuteString(decimalValue);

  return '$hourValue:$minuteString';
}

String getMinuteString(double decimalValue) {
  return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
}

String getHourString(int flooredValue) {
  return '$flooredValue'.padLeft(2, '0');
}

final numberFormat = intl.NumberFormat('#,##0.${"#" * 5}');

extension ExtOnNum on num {
  String format() {
    final parts = toString();
    return numberFormat.format(num.tryParse(parts));
  }
}

extension ClearFormats on String {
  int clearFormatsAndToInt() {
    return int.parse(
        replaceAll(",", "").replaceAll(".", "").replaceAll(" ", ""));
  }
}

extension ArabicDateFormat on DateTime {
  String arabicDateFormat({bool showDayOfWeek = false}) {
    // Format the date using 'yyyy-MM-dd' pattern and English numbers
    final dateFormat = intl.DateFormat('yyyy-MM-dd', 'en');

    // Format the day name in Arabic
    final dayFormat = intl.DateFormat.E('ar');

    final formattedDate = dateFormat.format(this);
    final formattedDay = dayFormat.format(this);
    if (showDayOfWeek) {
      return "$formattedDate  $formattedDay";
    } else {
      return formattedDate;
    }
  }
}
