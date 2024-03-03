import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(int) onRemove;
  final Function(int, bool) onToggleCompleted;

  const TaskList({
    Key? key,
    required this.tasks,
    required this.onRemove,
    required this.onToggleCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(
            '${task.id} - ${task.title}',
            style: TextStyle(
              decoration: task.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: task.isCompleted ? Colors.grey : null,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              task.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.isCompleted ? Colors.green : null,
            ),
            onPressed: () => onToggleCompleted(task.id, !task.isCompleted),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onRemove(task.id),
          ),
        );
      },
    );
  }
}
