import 'dart:convert';

class TaskModel {
  final String id;
  final String title;
  final String note;
  final bool isDone;
  final DateTime createdAt;
  final String createdBy; // 'manager' or 'driver'

  const TaskModel({
    required this.id,
    required this.title,
    this.note = '',
    this.isDone = false,
    required this.createdAt,
    required this.createdBy,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? note,
    bool? isDone,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'isDone': isDone,
        'createdAt': createdAt.toIso8601String(),
        'createdBy': createdBy,
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'] as String,
        title: json['title'] as String,
        note: json['note'] as String? ?? '',
        isDone: json['isDone'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        createdBy: json['createdBy'] as String? ?? '',
      );

  static String encodeList(List<TaskModel> tasks) =>
      jsonEncode(tasks.map((t) => t.toJson()).toList());

  static List<TaskModel> decodeList(String source) {
    final List<dynamic> list = jsonDecode(source) as List<dynamic>;
    return list
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
