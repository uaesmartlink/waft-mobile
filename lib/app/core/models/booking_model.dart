import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/models/package_model.dart';
import 'package:sport/app/core/models/user_model.dart';
import 'package:sport/app/core/services/data_list_mixin.dart';

class Booking extends PaginationId {
  final int id;
  final DateTime startTime;
  final DateTime endTime;
  final String type;
  final int slot;
  final int price;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final dynamic cancelReason;
  final dynamic cancelledBy;
  final DateTime createdAt;
  final Package package;
  final Activity stadium;
  final User? user;
//user: {id: 2, name: Khaled Debuch, email: muhammad.kadi.1999@gmail.com, phone: null}
  Booking({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.slot,
    required this.price,
    required this.completedAt,
    required this.cancelledAt,
    required this.cancelReason,
    required this.cancelledBy,
    required this.createdAt,
    required this.package,
    required this.stadium,
    required this.user,
  });

  factory Booking.fromMap(Map<String, dynamic> json) => Booking(
        id: json["id"],
        startTime: DateTime.parse(json["start_time"]).toLocal(),
        endTime: DateTime.parse(json["end_time"]).toLocal(),
        type: json["type"],
        slot: json["slot"],
        user: json["user"] == null ? null : User.fromMapMainInfo(json["user"]),
        price: json["price"],
        completedAt: json["completed_at"] == null
            ? null
            : DateTime.parse(json["completed_at"]).toLocal(),
        cancelledAt: json["cancelled_at"] == null
            ? null
            : DateTime.parse(json["cancelled_at"]).toLocal(),
        cancelReason: json["cancel_reason"],
        cancelledBy: json["cancelled_by"],
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        package: Package.fromMap(json["package"]),
        stadium: Activity.fromMap(json["stadium"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "type": type,
        "slot": slot,
        "price": price,
        "user": user?.toMap(),
        "completed_at": completedAt?.toIso8601String(),
        "cancelled_at": cancelledAt?.toIso8601String(),
        "cancel_reason": cancelReason,
        "cancelled_by": cancelledBy,
        "created_at": createdAt.toIso8601String(),
        "package": package.toMap(),
        "stadium": stadium.toMap(),
      };
  static List<Booking> bookings(List data) =>
      data.map((booking) => Booking.fromMap(booking)).toList();
}
