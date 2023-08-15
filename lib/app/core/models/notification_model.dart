import 'package:sport/app/core/services/data_list_mixin.dart';

class NotificationModel extends PaginationId {
  final int id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        title: json["title"] ?? "undefined",
        body: json["body"] ?? "undefined",
        isRead: json["is_read"] == 1,
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "body": body,
        "is_read": isRead,
        "created_at": createdAt.toIso8601String(),
      };
  static List<NotificationModel> notifications(List data) => data
      .map((notification) => NotificationModel.fromMap(notification))
      .toList();
}
