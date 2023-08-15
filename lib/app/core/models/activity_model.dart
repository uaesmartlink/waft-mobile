import 'package:sport/app/core/localization/translation.dart';
import 'package:sport/app/core/models/activity_type_model.dart';
import 'package:sport/app/core/models/holiday_model.dart';
import 'package:sport/app/core/models/package_model.dart';
import 'package:sport/app/core/models/service_model.dart';
import 'package:sport/app/core/models/worktime_model.dart';
import 'package:sport/app/core/services/data_list_mixin.dart';

class Activity extends PaginationId {
  final int id;
  final String name;
  final String nameEn;
  final String nameAr;
  final String mapUrl;
  final String image;
  final String description;
  final String descriptionEn;
  final String descriptionAr;
  final String address;
  final String addressEn;
  final String addressAr;
  final String phone;
  final String email;
  final String website;
  final String status;
  final int? regionId;
  final int? activityId;
  final int slot;
  final double? rating;
  final bool isFavorite;
  final int price;
  final int reviewCount;
  int? favoriteId;
  final List<WorkTime> workTimes;
  final List<Holiday> holidays;
  final List<ServiceModel> services;
  final List<Package> packages;
  final ActivityType? activityType;
  final List<ActivityImage> images;
  Activity({
    required this.id,
    required this.regionId,
    required this.activityId,
    required this.name,
    required this.mapUrl,
    required this.image,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.slot,
    required this.rating,
    required this.isFavorite,
    required this.price,
    required this.reviewCount,
    required this.favoriteId,
    required this.workTimes,
    required this.holidays,
    required this.services,
    required this.packages,
    required this.activityType,
    required this.images,
    required this.addressAr,
    required this.addressEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.nameAr,
    required this.nameEn,
    required this.status,
  });
  static List<Activity> activities(List data) =>
      data.map((activity) => Activity.fromMap(activity)).toList();
  factory Activity.fromMap(Map<String, dynamic> json) => Activity(
        id: json["id"],
        name: json["name_${Translation.languageCode}"] ??
            json["name"] ??
            "undefined",
        nameAr: json["name_ar"] ?? "undefined",
        nameEn: json["name_en"] ?? "undefined",
        mapUrl: json["map_url"] ?? "undefined",
        status: json["status"] ?? "Pending",
        image: json["image"] ?? "undefined",
        description: json["description_${Translation.languageCode}"] ??
            json["description"] ??
            "undefined",
        descriptionAr: json["description_ar"] ?? "undefined",
        descriptionEn: json["description_en"] ?? "undefined",
        address: json["address_${Translation.languageCode}"] ??
            json["address"] ??
            "undefined",
        addressAr: json["address_ar"] ?? "undefined",
        addressEn: json["address_en"] ?? "undefined",
        phone: json["phone"] ?? "undefined",
        email: json["email"] ?? "undefined",
        regionId: json["region_id"],
        activityId: json["activity_id"],
        website: json["website"] ?? "undefined",
        slot: json["slot"]?.toInt() ?? 0,
        rating: json["rating"]?.toDouble() ??
            double.tryParse(json["average_rating"] ?? ""),
        isFavorite: json["is_favorite"] ?? false,
        price: json["price"]?.toInt() ?? 0,
        reviewCount: json["review_count"]?.toInt() ?? 0,
        favoriteId: json["favorite_id"],
        workTimes: WorkTime.workTimes(json["workTimes"] ?? []),
        holidays: Holiday.holidays(json["holidays"] ?? []),
        services: ServiceModel.services(json["services"] ?? []),
        packages: Package.packages(json["packages"] ?? []),
        images: ActivityImage.activityImages(json["images"] ?? []),
        activityType:
            json["activities"] != null && json["activities"].isNotEmpty
                ? ActivityType.fromMap(json["activities"][0])
                : null,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "map_url": mapUrl,
        "image": image,
        "description": description,
        "address": address,
        "phone": phone,
        "email": email,
        "website": website,
        "status": status,
        "slot": slot,
        "rating": rating,
        "is_favorite": isFavorite,
        "price": price,
        "review_count": reviewCount,
        "favorite_id": favoriteId,
        "workTimes": workTimes.map((e) => e.toMap()).toList(),
        "holidays": holidays.map((e) => e.toMap()).toList(),
        "services": services.map((e) => e.toMap()).toList(),
        "packages": packages.map((e) => e.toMap()).toList(),
        "images": images.map((e) => e.toMap()).toList(),
        "activities": activityType?.toMap(),
      };
}

class ActivityImage {
  final int id;
  final String imagePath;

  ActivityImage({
    required this.id,
    required this.imagePath,
  });

  factory ActivityImage.fromMap(Map<String, dynamic> json) => ActivityImage(
        id: json["id"],
        imagePath: json["image_path"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "image_path": imagePath,
      };
  static List<ActivityImage> activityImages(List data) => data
      .map((activityImage) => ActivityImage.fromMap(activityImage))
      .toList();
}
