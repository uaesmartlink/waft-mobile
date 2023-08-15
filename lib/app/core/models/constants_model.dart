import 'dart:io';

import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/translation.dart';

class Constants {
  final AppVersion appVersionAndroid;
  final AppVersion appVersionIos;
  final List<Onboarding> onboarding;
  final String supportPhoneNumber;
  final String privacyPolicy;
  final String termsAndConditions;
  final String aboutUs;
  AppVersion get appVersion =>
      Platform.isAndroid ? appVersionAndroid : appVersionIos;
  Constants({
    required this.appVersionAndroid,
    required this.appVersionIos,
    required this.onboarding,
    required this.supportPhoneNumber,
    required this.privacyPolicy,
    required this.termsAndConditions,
    required this.aboutUs,
  });

  factory Constants.fromMap(Map<String, dynamic> json) => Constants(
        appVersionAndroid: AppVersion.fromMap(json["app_version_android"]),
        appVersionIos: AppVersion.fromMap(json["app_version_ios"]),
        onboarding: List<Onboarding>.from(
            json["onboarding"].map((x) => Onboarding.fromMap(x))),
        supportPhoneNumber: json["support_phone_number"],
        privacyPolicy: json["privacy_policy"],
        termsAndConditions: json["terms_and_conditions"],
        aboutUs: json["about_us"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "app_version_android": appVersionAndroid.toMap(),
        "app_version_ios": appVersionIos.toMap(),
        "onboarding": List<dynamic>.from(onboarding.map((x) => x.toMap())),
        "support_phone_number": supportPhoneNumber,
        "privacy_policy": privacyPolicy,
        "terms_and_conditions": termsAndConditions,
        "about_us": aboutUs,
      };
}

class AppVersion {
  final int latestVersionCode;
  final String versionName;
  final String storeLink;
  final int minimumVersionCode;
  final String aboutThisVersion;
  final int hoursNumberToRepeat;
  DateTime hideUntil;

  AppVersion({
    required this.latestVersionCode,
    required this.versionName,
    required this.storeLink,
    required this.minimumVersionCode,
    required this.aboutThisVersion,
    required this.hoursNumberToRepeat,
    required this.hideUntil,
  });

  factory AppVersion.fromMap(Map<String, dynamic> json) => AppVersion(
        latestVersionCode: json["latest_version_code"],
        versionName: json["version_name"],
        storeLink: json["store_link"],
        minimumVersionCode: json["minimum_version_code"],
        aboutThisVersion:
            json["about_this_version_${Translation.languageCode}"] ??
                json["about_this_version"],
        hoursNumberToRepeat: json["hours_number_to_repeat"],
        hideUntil: json["hide_until"] != null
            ? DateTime.parse(json['hide_until'])
            : DataHelper.constants != null
                ? DataHelper.constants!.appVersion.hideUntil
                : DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        "latest_version_code": latestVersionCode,
        "version_name": versionName,
        "store_link": storeLink,
        "minimum_version_code": minimumVersionCode,
        "about_this_version": aboutThisVersion,
        "hours_number_to_repeat": hoursNumberToRepeat,
        "hide_until": hideUntil.toIso8601String(),
      };
  bool get forceUpdate {
    return minimumVersionCode >
        (int.tryParse(DataHelper.packageInfo.buildNumber) ?? 1);
  }

  bool get showUpdate => DateTime.now().isAfter(hideUntil);

  void ignore() =>
      hideUntil = DateTime.now().add(Duration(hours: hoursNumberToRepeat));
}

class Onboarding {
  final String title;
  final String description;
  final String imageUrl;

  Onboarding({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Onboarding.fromMap(Map<String, dynamic> json) => Onboarding(
        title: json["title_${Translation.languageCode}"] ?? json["title"],
        description: json["description_${Translation.languageCode}"] ??
            json["description"],
        imageUrl:
            json["imageUrl_${Translation.languageCode}"] ?? json["imageUrl"],
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "description": description,
        "imageUrl": imageUrl,
      };
}
