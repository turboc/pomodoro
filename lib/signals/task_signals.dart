import 'package:hive/hive.dart';
import '../models/task.dart';
import 'package:signals/signals.dart';

final Signal<List<Task>> tasks = signal([]);

late Box<Task> taskBox;

Future<void> openBoxes() async {
  taskBox = await Hive.openBox<Task>('tasks');
}

void addTask(String title) async {
  final task = Task(id: 0, title: title);
  await taskBox.add(task);
  tasks.value = getAllTasks();
}

void removeTask(int id) async {
  await taskBox.delete(id);
  tasks.value = getAllTasks();
}

void toggleTaskCompleted(int id, bool isCompleted) async {
  final task = taskBox.get(id);
  if (task != null) {
    task.isCompleted = isCompleted;
    await task.save();
    tasks.value = getAllTasks();
  }
}

List<Task> getAllTasks() {
  List<Task> tasks = [];
  for (int taskId in taskBox.keys) {
    Task task = taskBox.get(taskId)!;
    task.id = taskId;
    tasks.add(task);
  }
  return tasks;
}

// computed
Computed getTasks() {
  return computed(() => tasks());
}
