import '../models/task.dart';
import 'package:signals/signals.dart';

final Signal<List<Task>> _tasks = signal([]);

void _addTask(String title) {
  if (title.isNotEmpty) {
    _tasks.get().add(Task(title: title));
  }
}

void _removeTask(int index) {
  _tasks.get().removeAt(index);
}

void _toggleTaskCompleted(int index) {
  _tasks.get()[index].isCompleted = !_tasks.get()[index].isCompleted;
}
