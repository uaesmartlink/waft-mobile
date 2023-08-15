import 'package:sport/app/core/localization/translation.dart';

class ServiceModel {
  final int id;
  final String name;
  final String? icon;

  ServiceModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> json) => ServiceModel(
        id: json["stadium_service_id"] ?? json["id"],
        name: json["name_${Translation.languageCode}"] ?? json["name"],
        icon: json["icon"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "icon": icon,
      };
  static List<ServiceModel> services(List data) =>
      data.map((service) => ServiceModel.fromMap(service)).toList();
}
