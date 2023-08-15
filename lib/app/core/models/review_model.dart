import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/models/user_model.dart';
import 'package:sport/app/core/services/data_list_mixin.dart';

class Review extends PaginationId {
  final int id;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final User user;
  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.user,
  });

  factory Review.fromMap(Map<String, dynamic> json) => Review(
        id: json["id"],
        rating: json["rating"]?.toDouble(),
        comment: json["comment"] ?? "",
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        user: User.fromMap(json["user"] ?? DataHelper.user?.toMap()),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "rating": rating,
        "comment": comment,
        "user": user.toMap(),
        "created_at": createdAt.toIso8601String(),
      };
  static List<Review> reviews(List data) =>
      data.map((review) => Review.fromMap(review)).toList();
}
