class WorkTime {
  final int id;
  final String day;
  final String startTime;
  final String endTime;

  WorkTime({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory WorkTime.fromMap(Map<String, dynamic> json) => WorkTime(
        id: json["id"],
        day: json["day"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "day": day,
        "start_time": startTime,
        "end_time": endTime,
      };
  static List<WorkTime> workTimes(List data) =>
      data.map((workTime) => WorkTime.fromMap(workTime)).toList();
}
