import 'package:sport/app/core/utils/enum_converter.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final DateTime? birthday;
  final Gender? gender;
  final bool blocked;
  final DateTime createdAt;
  final String image;
  final String token;
  final DateTime expiresInDate;
  final AccountType browsingType;
  final AccountType role;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.birthday,
    required this.gender,
    required this.blocked,
    required this.createdAt,
    required this.image,
    required this.expiresInDate,
    required this.token,
    required this.browsingType,
    required this.role,
  });

  factory User.fromMap(Map<String, dynamic> json,
          {String? token, DateTime? expiresInDate}) =>
      User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        birthday: json["birthday"] == null
            ? null
            : DateTime.parse(json["birthday"]).toLocal(),
        gender: _parseGender(json["gender"] == null
            ? null
            : json["gender"].runtimeType == int
                ? json["gender"]
                : int.parse(json["gender"])),
        blocked: json["blocked"] == 1 ? true : false,
        createdAt: json["created_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["created_at"]).toLocal(),
        browsingType:
            accountTypes.map[json["browsing_mode"]]!, //?? AccountType.user,
        role: accountTypes.map[json["role"]]!, //?? AccountType.manager,
        image: json["image"] ??
            "https://sharp-galois.82-165-238-229.plesk.page/storage/images/activity/1688659204_7540.jpg",
        expiresInDate: expiresInDate ??
            (json["expires_in_date"] != null
                ? DateTime.parse(json["expires_in_date"]).toLocal()
                : DateTime.now().add(const Duration(hours: 1))),
        token: token ?? json["token"] ?? "",
      );
  factory User.fromMapMainInfo(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        phone: json["phone"],
        birthday: json["birthday"] == null
            ? null
            : DateTime.parse(json["birthday"]).toLocal(),
        gender: _parseGender(json["gender"] == null
            ? null
            : json["gender"].runtimeType == int
                ? json["gender"]
                : int.parse(json["gender"])),
        blocked: json["blocked"] == 1 ? true : false,
        createdAt: json["created_at"] == null
            ? DateTime.now()
            : DateTime.parse(json["created_at"]).toLocal(),
        browsingType: AccountType.user,
        role: AccountType.user,
        image: json["image"] ??
            "https://sharp-galois.82-165-238-229.plesk.page/storage/images/activity/1688659204_7540.jpg",
        expiresInDate: DateTime.now(),
        token: json["token"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "birthday": birthday?.toIso8601String(),
        "gender": getGenderString,
        "blocked": blocked ? 1 : 0,
        "created_at": createdAt.toIso8601String(),
        "image": image,
        "browsing_mode": browsingTypeName,
        "role": roleName,
        "token": token,
        "expires_in_date": expiresInDate.toIso8601String(),
      };
  String get browsingTypeName => accountTypes.reverse[browsingType]!;
  String get roleName => accountTypes.reverse[role]!;
  User copyWith({
    String? token,
    String? email,
    DateTime? expiresInDate,
  }) =>
      User(
        id: id,
        name: name,
        email: email ?? this.email,
        phone: phone,
        birthday: birthday,
        gender: gender,
        blocked: blocked,
        createdAt: createdAt,
        browsingType: browsingType,
        role: role,
        image: image,
        expiresInDate: expiresInDate ?? this.expiresInDate,
        token: token ?? this.token,
      );
  static Gender _parseGender(int? gender) {
    switch (gender) {
      case 1:
        return Gender.male;
      case 2:
        return Gender.female;
      default:
        return Gender.other;
    }
  }

  int? get getGenderString {
    switch (gender) {
      case Gender.male:
        return 1;
      case Gender.female:
        return 2;
      default:
        return null;
    }
  }
}

enum Gender {
  male,
  female,
  other,
}

enum AccountType {
  user,
  manager,
}

final accountTypes = EnumValues(
    {"user": AccountType.user, "stadium_manager": AccountType.manager});
