import 'package:hive/hive.dart';

part 'task.g.dart'; // You need to generate this file using the command `flutter pub run build_runner build`

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
