import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pomodoro/widgets/task_list.dart';
import 'models/task.dart';

void main() {
  runApp(const MyApp());
}

// apenas teste
const increment = 10;

enum TimerState { focus, shortBreak, longBreak }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Turboc Pomodoro'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FocusNode _focusNode = FocusNode();

  int _time = 1 * 5;
  String _currentStateText = "Foco";
  TimerState _currentState = TimerState.focus;

  Timer? _timer;
  final player = AudioPlayer();
  final List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    if (_time == 0) {
      setState(() => _time = increment);
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_time > 0) {
        setState(() => _time--);
      } else {
        _timer!.cancel();
        _playAudio();
      }
    });
  }

  void _stopTimer() {
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
      switch (s) {
        case TimerState.focus:
          {
            _currentStateText = "Foco";
            _time = 5;
            break;
          }
        case TimerState.shortBreak:
          {
            _currentStateText = "Intervalo breve";
            _time = 3;
            break;
          }
        case TimerState.longBreak:
          {
            _currentStateText = "Intervalo longo";
            _time = 10;
            break;
          }
      }
    });
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

  void _playAudio() async {
    await player.play(AssetSource('audio/gongo2.mp3'));
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 1.0),
                      child: Text(
                        _currentStateText,
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _getTimeCounter(),
                        style: const TextStyle(
                            fontSize: 96, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),

                      // Isso ta uma bagunca. Refatorar adicionando um control
                      // de estado, nao apenas para o tipo de timer,
                      // mas tambem o estado em que se encontra o timer e o app
                      if (_timer != null && _timer!.isActive && _time > 0)
                        Image.asset('assets/images/yy_cheering.png', width: 100)
                      else if (_timer != null && _timer!.isActive && _time == 0)
                        Image.asset('assets/images/yy_ok.png', width: 100)
                      else if ((_timer == null || !_timer!.isActive) &&
                          _time > 0)
                        Image.asset('assets/images/yy_sitting.png', width: 200)
                      else if ((_timer == null || !_timer!.isActive) &&
                          _time == 0)
                        Image.asset('assets/images/yy_sleeping.png',
                            width: 300),
                    ],
                  ),
                  Row(
                    children: [
                      if (_time < 1)
                        ElevatedButton(
                          onPressed: _startTimer,
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(230, 100)),
                          child: const Text('Iniciar'),
                        )
                      else if (_timer == null || !_timer!.isActive)
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: _stopTimer,
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(230, 100)),
                              child: const Text('Parar'),
                            ),
                            ElevatedButton(
                              onPressed: _resumeTimer,
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(230, 100)),
                              child: const Text('Reiniciar'),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: _stopTimer,
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(230, 100)),
                              child: const Text('Parar'),
                            ),
                            ElevatedButton(
                              onPressed: _pauseTimer,
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(230, 100)),
                              child: const Text('Pause'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              _selectState(TimerState.focus);
            },
            tooltip: 'Foco',
            backgroundColor: _currentState == TimerState.focus
                ? Colors.purpleAccent
                : Colors.grey,
            child: const Icon(Icons.rocket_launch_sharp),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              _selectState(TimerState.shortBreak);
            },
            tooltip: 'Intervalo breve',
            backgroundColor: _currentState == TimerState.shortBreak
                ? Colors.purpleAccent
                : Colors.grey,
            child: const Icon(Icons.coffee_sharp),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              _selectState(TimerState.longBreak);
            },
            tooltip: 'Intervalo longo',
            backgroundColor: _currentState == TimerState.longBreak
                ? Colors.purpleAccent
                : Colors.grey,
            child: const Icon(Icons.lunch_dining_sharp),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () {
              _decrementTime();
            },
            tooltip: 'Decrementar tempo',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _incrementTime,
            tooltip: 'Incrementar tempo',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
