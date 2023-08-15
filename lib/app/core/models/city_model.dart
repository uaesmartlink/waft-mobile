import 'package:sport/app/core/localization/translation.dart';

class City {
  final int id;
  final String name;

  City({
    required this.id,
    required this.name,
  });

  factory City.fromMap(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name_${Translation.languageCode}"] ?? json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
  static List<City> cities(List data) =>
      data.map((city) => City.fromMap(city)).toList();
}
