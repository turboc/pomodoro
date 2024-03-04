import 'package:hive/hive.dart';

part 'task.g.dart'; // `flutter pub run build_runner build`

@HiveType(typeId: 0)
class Task extends HiveObject {
  // Not a HiveField(0)
  int id;

  @HiveField(0)
  String title;

  @HiveField(1)
  bool isCompleted;

  @HiveField(2)
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
