class Statistics {
  final int totalBookings;
  final int completedBookings;
  final int canceledBookings;
  final int todayBookings;
  final int totalAmount;

  Statistics({
    required this.totalBookings,
    required this.completedBookings,
    required this.canceledBookings,
    required this.todayBookings,
    required this.totalAmount,
  });

  factory Statistics.fromMap(Map<String, dynamic> json) => Statistics(
        totalBookings: json["total_bookings"]?.toInt() ?? 0,
        completedBookings: json["completed_bookings"]?.toInt() ?? 0,
        canceledBookings: json["canceled_bookings"]?.toInt() ?? 0,
        todayBookings: json["today_bookings"]?.toInt() ?? 0,
        totalAmount: json["total_amount"].runtimeType == int
            ? json["total_amount"]
            : double.tryParse(json["total_amount"] ?? "0.0")?.toInt() ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "total_bookings": totalBookings,
        "completed_bookings": completedBookings,
        "canceled_bookings": canceledBookings,
        "today_bookings": todayBookings,
        "total_amount": totalAmount,
      };
}
