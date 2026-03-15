class BookingsData {
  String? id;
  int? maxTime;
  DateTime? createdAt;
  DateTime? updatedAt;

  BookingsData({
    required this.id,
    required this.maxTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingsData.fromJson(Map<String, dynamic> json) => BookingsData(
    id: json["id"]?.toString(),
    maxTime: json["max_time"] ?? 23,
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "max_time": maxTime,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
