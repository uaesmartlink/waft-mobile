import 'package:intl/intl.dart';
import 'package:sport/app/core/localization/translation.dart';

class AvailableTime {
  final String time;
  final bool booked;

  AvailableTime({
    required this.time,
    required this.booked,
  });
  static List<AvailableTime> availableTimes(List data) => data
      .map((availableTime) => AvailableTime.fromMap(availableTime))
      .toList();
  factory AvailableTime.fromMap(Map<String, dynamic> json) => AvailableTime(
        time: json["time"],
        booked: json["status"] == "booked",
      );
  String get dateFormated {
    DateTime parsedTime = DateFormat.Hm().parse(time);
    String formattedTimeNumber = DateFormat("hh:mm").format(parsedTime);
    String formattedTime =
        DateFormat("a", Translation.currentLanguage.languageCode)
            .format(parsedTime);
    return "$formattedTimeNumber $formattedTime";
  }

  Map<String, dynamic> toMap() => {
        "time": time,
        "booked": booked,
      };
}
