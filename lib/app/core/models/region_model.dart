import 'package:sport/app/core/localization/translation.dart';

class Region {
  final int id;
  final String name;

  Region({
    required this.id,
    required this.name,
  });

  factory Region.fromMap(Map<String, dynamic> json) => Region(
        id: json["id"],
        name: json["name_${Translation.languageCode}"] ?? json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
  static List<Region> regions(List data) =>
      data.map((city) => Region.fromMap(city)).toList();
}
