import 'package:sport/app/core/localization/translation.dart';

class BannerModel {
  final int id;
  final String title;
  final String image;
  final String link;
  final DateTime createdAt;
  final DateTime updatedAt;

  BannerModel({
    required this.id,
    required this.title,
    required this.image,
    required this.link,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BannerModel.fromMap(Map<String, dynamic> json) => BannerModel(
        id: json["id"],
        title: json["title_${Translation.languageCode}"] ?? json["title"],
        image: json["image_${Translation.languageCode}"] ?? json["image"],
        link: json["link"],
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "image": image,
        "link": link,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
  static List<BannerModel> banners(List data) =>
      data.map((banner) => BannerModel.fromMap(banner)).toList();
}
