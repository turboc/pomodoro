import 'package:flutter/material.dart';
import 'package:pomodoro/util/constants.dart';
import 'package:pomodoro/widgets/task_list.dart';
import 'package:pomodoro/widgets/timer_control_panel.dart';
import 'package:pomodoro/widgets/actions_panel.dart';
import 'package:signals/signals_flutter.dart';
import 'package:pomodoro/signals/timer_signals.dart' as ts;
import '../models/task.dart';

class PomodoroMainPage extends StatefulWidget {
  const PomodoroMainPage({super.key, required this.title});

  final String title;

  @override
  State<PomodoroMainPage> createState() => _PomodoroMainPage();
}

class _PomodoroMainPage extends State<PomodoroMainPage> {
  final FocusNode _focusNode = FocusNode();

  final List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  void _addTask(String title) {
    if (title.isNotEmpty) {
      setState(() => _tasks.add(Task(title: title)));
      _taskController.clear();
    }
  }

  void _removeTask(int index) {
    setState(() => _tasks.removeAt(index));
  }

  void _toggleTaskCompleted(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _taskController,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Adicionar tarefa',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) {
                        _addTask(value);
                        _focusNode.requestFocus();
                      },
                    ),
                  ),
                  Expanded(
                    child: TaskList(
                      tasks: _tasks,
                      onRemove: _removeTask,
                      onToggleCompleted: _toggleTaskCompleted,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: TimerControlPanel(
                currentStateText:
                    ts.getCurrentStateText().watch(context),
                timeCounter: ts.getTimeCounter().watch(context),
                timer: ts.getTimer().watch(context),
                time: ts.getTime().watch(context),
                generalState:
                    ts.getSignalGeneralState().watch(context),
                onStartTimer: ts.startTimer,
                onStopTimer: ts.stopTimer,
                onPauseTimer: ts.pauseTimer,
                onResumeTimer: ts.startTimer,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ActionsPanel(
        onSelectFocus: () => ts.setSelectedState(TimerState.focus),
        onSelectShortBreak: () =>
            ts.setSelectedState(TimerState.shortBreak),
        onSelectLongBreak: () =>
            ts.setSelectedState(TimerState.longBreak),
        onDecrementTime: ts.decrementTime,
        onIncrementTime: ts.incrementTime,
        timerState: ts.getTimerState().watch(context),
      ),
    );
  }
}
