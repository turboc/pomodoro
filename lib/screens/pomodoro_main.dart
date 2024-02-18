import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:pomodoro/util/constants.dart';
import 'package:pomodoro/util/util_functions.dart';
import 'package:pomodoro/widgets/task_list.dart';
import '../models/task.dart';
import 'package:pomodoro/widgets/timer_control_panel.dart';
import 'package:pomodoro/widgets/actions_panel.dart';

class PomodoroMainPage extends StatefulWidget {
  const PomodoroMainPage({super.key, required this.title});

  final String title;

  @override
  State<PomodoroMainPage> createState() => _PomodoroMainPage();
}

class _PomodoroMainPage extends State<PomodoroMainPage> {
  final FocusNode _focusNode = FocusNode();

  int _time = timeLimits.elementAt(0);
  bool _gongado = false;
  String _currentStateText = "Foco";
  TimerState _currentState = TimerState.focus;

  Timer? _timer;
  final player = AudioPlayer();
  final List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  void _startTimer() {
    _playAudioStart();
    if (_timer != null) {
      _timer!.cancel();
    }
    if (_time == 0) {
      setState(() => _time = increment);
    }
    _gongado = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {

      _canPlayGongo();

      if (_time > 0) {
        setState(() => _time--);
      } else {
        _timer!.cancel();
      }
    });
  }

  void _stopTimer() {

    _playAudioStop();

    if (_timer != null) {
      setState(() {
        _timer!.cancel();
        _timer = null;
        _time = 0;
      });
    } else {
      setState(() {
        _time = 0;
      });
    }
  }

  void _pauseTimer() {

    _playAudioPause();

    if (_timer != null) {
      setState(() {
        _timer!.cancel();
        _timer = null;
      });
    }
  }

  void _resumeTimer() {
    _startTimer();
  }

  void _selectState(TimerState s) {
    setState(() {
      _currentState = s;
      _currentStateText = timeLimitsText.elementAt(s.index);
      _time = timeLimits.elementAt(s.index);
    });
    _playAudioMovMenu();
  }

  void _incrementTime() {
    setState(() {
      _time += increment;
      if (_timer == null || !_timer!.isActive) {
        _startTimer();
      }
    });
  }

  void _decrementTime() {
    setState(() {
      _time -= increment;
      if (_time <= 0) {
        _stopTimer();
      }
    });
  }

  void _canPlayGongo() {
    if (_time < 2 && !_gongado) {
      _playAudioGongo();
    }
  }

  void _playAudioGongo() async {
    _gongado = true;
    switch (getGeneralState(_currentState, _timer, _time)) {
      case GeneralState.focusStopped:
      case GeneralState.focusRunning: 
        {
          _playAudio(gongoSound);
          break;
        }
      case GeneralState.longBreakStopped:
      case GeneralState.shortBreakStopped:
      case GeneralState.longBreakRunning:
      case GeneralState.shortBreakRunning:
        {
          _playAudio(panicGongoSound);
          break;
        }
      default:
        {
          _playAudio(gongoSound);
        }
    }
  }

  void _playAudioMovMenu() async {
    _playAudio(movMenu);
  }


  void _playAudioStop() async {
    _playAudio(stopSound);
  }

  void _playAudioStart() async {
    _playAudio(startSound);
  }
  void _playAudioPause() async {
    _playAudio(pauseSound);
  }


  void _playAudio(String whatSound) async {
    await player.play(AssetSource(whatSound));
  }

  String _getTimeCounter() {
    int minutes = _time ~/ 60;
    int seconds = _time % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

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
    _timer?.cancel();
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
                currentStateText: _currentStateText,
                timeCounter: _getTimeCounter(),
                timer: _timer,
                time: _time,
                generalState: getGeneralState(_currentState, _timer, _time),
                onStartTimer: _startTimer,
                onStopTimer: _stopTimer,
                onPauseTimer: _pauseTimer,
                onResumeTimer: _resumeTimer,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ActionsPanel(
        onSelectFocus: () => _selectState(TimerState.focus),
        onSelectShortBreak: () => _selectState(TimerState.shortBreak),
        onSelectLongBreak: () => _selectState(TimerState.longBreak),
        onDecrementTime: _decrementTime,
        onIncrementTime: _incrementTime,
        isFocus: _currentState == TimerState.focus,
        isShortBreak: _currentState == TimerState.shortBreak,
        isLongBreak: _currentState == TimerState.longBreak,
      ),
    );
  }
}
