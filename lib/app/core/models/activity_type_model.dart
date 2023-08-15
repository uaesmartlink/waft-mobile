import 'package:sport/app/core/localization/translation.dart';
import 'package:sport/app/core/services/data_list_mixin.dart';

class ActivityType extends PaginationId {
  final int id;
  final String name;
  final String image;

  ActivityType({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ActivityType.fromMap(Map<String, dynamic> json) => ActivityType(
        id: json["id"],
        image: json["image"] ??
            "https://sharp-galois.82-165-238-229.plesk.page/storage/images/activity/1688659204_7540.jpg",
        name: json["name_${Translation.languageCode}"] ?? json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "image": image,
      };
  static List<ActivityType> activityTypes(List data) =>
      data.map((city) => ActivityType.fromMap(city)).toList();
}
