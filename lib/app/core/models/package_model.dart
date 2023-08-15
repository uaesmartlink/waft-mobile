import 'package:sport/app/core/localization/translation.dart';

class Package {
  final int id;
  final String name;
  final int price;
  final int slot;
  final PackageType packageType;
  final SlotType slotType;

  Package({
    required this.id,
    required this.name,
    required this.price,
    required this.slot,
    required this.packageType,
    required this.slotType,
  });

  factory Package.fromMap(Map<String, dynamic> json) => Package(
        id: json["id"],
        name: json["name_${Translation.languageCode}"] ?? json["name"],
        price: json["price"],
        slot: json["slot"],
        packageType: _parsePackageType(json["type"]),
        slotType: _parseSlotType(json["slot_type"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "price": price,
        "slot": slot,
        "type": getPackageTypeString,
        "slot_type": slotType.name,
      };
  static List<Package> packages(List data) =>
      data.map((package) => Package.fromMap(package)).toList();
  static PackageType _parsePackageType(String? packageType) {
    switch (packageType) {
      case "subscription":
        return PackageType.subscription;
      case "time_slot":
        return PackageType.timeSlot;
      default:
        return PackageType.timeSlot;
    }
  }

  static SlotType _parseSlotType(String? slotType) {
    switch (slotType) {
      case "minutes":
        return SlotType(slotType!, 1);
      case "hours":
        return SlotType(slotType!, 60);
      case "days":
        return SlotType(slotType!, 1440);
      case "years":
        return SlotType(slotType!, 525600);
      default:
        return SlotType(slotType!, 1);
    }
  }

  String? get getPackageTypeString {
    switch (packageType) {
      case PackageType.subscription:
        return "subscription";
      case PackageType.timeSlot:
        return "time_slot";
      default:
        return null;
    }
  }
}

enum PackageType {
  subscription,
  timeSlot,
}

class PackageTypeName {
  final String name;
  final String value;

  PackageTypeName(this.name, this.value);
}

class SlotType {
  final String name;
  final int value;

  SlotType(this.name, this.value);
  @override
  bool operator ==(Object other) {
    return (other is SlotType) && other.name == name && other.value == value;
  }

  @override
  int get hashCode => super.hashCode * value;
}
