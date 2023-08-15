import 'package:sport/app/core/localization/translation.dart';

class Holiday {
  final int id;
  final String name;
  final DateTime date;

  Holiday({
    required this.id,
    required this.name,
    required this.date,
  });

  factory Holiday.fromMap(Map<String, dynamic> json) => Holiday(
        id: json["id"],
        name: json["name_${Translation.languageCode}"] ?? json["name"],
        date: DateTime.parse(json["date"]).toLocal(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "date": date.toIso8601String(),
      };
  static List<Holiday> holidays(List data) =>
      data.map((holiday) => Holiday.fromMap(holiday)).toList();
}
