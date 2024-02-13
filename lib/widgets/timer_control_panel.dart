import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodoro/util/constants.dart';

class TimerControlPanel extends StatelessWidget {
  final String currentStateText;
  final String timeCounter;
  final Timer? timer;
  final int time;
  final VoidCallback onStartTimer;
  final VoidCallback onStopTimer;
  final VoidCallback onPauseTimer;
  final VoidCallback onResumeTimer;

  const TimerControlPanel({
    Key? key,
    required this.currentStateText,
    required this.timeCounter,
    required this.timer,
    required this.time,
    required this.onStartTimer,
    required this.onStopTimer,
    required this.onPauseTimer,
    required this.onResumeTimer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 1.0),
            child: Text(
              currentStateText,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              timeCounter,
              style: const TextStyle(fontSize: 96, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20),
            _buildImageBasedOnTimerState(),
          ],
        ),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildImageBasedOnTimerState() {
    if (timer != null && timer!.isActive && time > 0) {
      return Image.asset(imageCheering, width: 100);
    } else if (timer != null && timer!.isActive && time == 0) {
      return Image.asset(imageOk, width: 100);
    } else if ((timer == null || !timer!.isActive) && time > 0) {
      return Image.asset(imageSitting, width: 200);
    } else {
      return Image.asset(imageSleeping, width: 300);
    }
  }

  Widget _buildActionButtons() {
    if (time < 1) {
      return Row(
        children: [
          ElevatedButton(
            onPressed: onStartTimer,
            style: ElevatedButton.styleFrom(minimumSize: const Size(230, 100)),
            child: const Text('Iniciar'),
          )
        ],
      );
    } else if (timer == null || !timer!.isActive) {
      return Row(
        children: [
          ElevatedButton(
            onPressed: onStopTimer,
            style: ElevatedButton.styleFrom(minimumSize: const Size(230, 100)),
            child: const Text('Parar'),
          ),
          ElevatedButton(
            onPressed: onResumeTimer,
            style: ElevatedButton.styleFrom(minimumSize: const Size(230, 100)),
            child: const Text('Reiniciar'),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          ElevatedButton(
            onPressed: onStopTimer,
            style: ElevatedButton.styleFrom(minimumSize: const Size(230, 100)),
            child: const Text('Parar'),
          ),
          ElevatedButton(
            onPressed: onPauseTimer,
            style: ElevatedButton.styleFrom(minimumSize: const Size(230, 100)),
            child: const Text('Pause'),
          ),
        ],
      );
    }
  }
}
