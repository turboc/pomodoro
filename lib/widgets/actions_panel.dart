// actions_panel.dart

import 'package:flutter/material.dart';

class ActionsPanel extends StatelessWidget {
  final VoidCallback onSelectFocus;
  final VoidCallback onSelectShortBreak;
  final VoidCallback onSelectLongBreak;
  final VoidCallback onDecrementTime;
  final VoidCallback onIncrementTime;
  final bool isFocus;
  final bool isShortBreak;
  final bool isLongBreak;

  const ActionsPanel({
    Key? key,
    required this.onSelectFocus,
    required this.onSelectShortBreak,
    required this.onSelectLongBreak,
    required this.onDecrementTime,
    required this.onIncrementTime,
    required this.isFocus,
    required this.isShortBreak,
    required this.isLongBreak,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          onPressed: onSelectFocus,
          tooltip: 'Foco',
          backgroundColor: isFocus ? Colors.purpleAccent : Colors.grey,
          child: const Icon(Icons.rocket_launch_sharp),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          onPressed: onSelectShortBreak,
          tooltip: 'Intervalo breve',
          backgroundColor: isShortBreak ? Colors.purpleAccent : Colors.grey,
          child: const Icon(Icons.coffee_sharp),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          onPressed: onSelectLongBreak,
          tooltip: 'Intervalo longo',
          backgroundColor: isLongBreak ? Colors.purpleAccent : Colors.grey,
          child: const Icon(Icons.lunch_dining_sharp),
        ),
        const SizedBox(width: 20),
        FloatingActionButton(
          onPressed: onDecrementTime,
          tooltip: 'Decrementar tempo',
          child: const Icon(Icons.remove),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          onPressed: onIncrementTime,
          tooltip: 'Incrementar tempo',
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
