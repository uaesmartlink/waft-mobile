import 'package:sport/app/core/services/data_list_mixin.dart';

class Transaction extends PaginationId {
  final int id;
  final String amount;
  final DateTime createdAt;
  final bool completed;
  final bool refunded;

  Transaction({
    required this.id,
    required this.amount,
    required this.createdAt,
    required this.completed,
    required this.refunded,
  });

  factory Transaction.fromMap(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        amount: json["amount"],
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        completed: json["status"] == "CAPTURED",
        refunded: json["status"] == "REFUNDED",
      );
  static List<Transaction> transactions(List data) =>
      data.map((transaction) => Transaction.fromMap(transaction)).toList();
  Map<String, dynamic> toMap() => {
        "id": id,
        "amount": amount,
        "created_at": createdAt.toIso8601String(),
        "status": completed
            ? "CAPTURED"
            : refunded
                ? "REFUNDED"
                : "INITIATED",
      };
}
