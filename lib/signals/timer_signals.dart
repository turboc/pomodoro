import 'dart:async';
import 'package:signals/signals.dart';
import 'package:pomodoro/util/constants.dart';
import 'package:pomodoro/controllers/audio_controller.dart';
import 'package:pomodoro/util/util_functions.dart';

final Signal<int> time = signal(timeLimits.elementAt(0));
final Signal<TimerState> timerState = signal(TimerState.focus);
final Signal<String> timerStateText = signal("Foco");
final Signal<Timer?> timer = signal(null);
final AudioController audioController = AudioController();

bool gongado = false;

void _canPlayGongo() {
  if (time.value < 2 && !gongado) {
    playAudioGongo();
  }
}

void playAudioGongo() {
  gongado = true;
  switch (getGeneralState(timerState.value, timer.value, time.value)) {
    case GeneralState.longBreakStopped:
    case GeneralState.shortBreakStopped:
    case GeneralState.longBreakRunning:
    case GeneralState.shortBreakRunning:
      {
        audioController.playPanicGongo();
        break;
      }
    default:
      {
        audioController.playGongo();
      }
  }

  audioController.playGongo();
}

void startTimer() {
  audioController.playStart();

  timer.value?.cancel();

  if (time.value == 0) {
    time.value = increment;
  }
  gongado = false;

  timer.value = Timer.periodic(const Duration(seconds: 1), (t) {
    _canPlayGongo();

    if (time.value > 0) {
      time.value = time.value - 1;
    } else {
      timer.value!.cancel();
      timer.value = null;
    }
  });
}

void stopTimer() {
  audioController.playStop();

  timer.value?.cancel();
  timer.value = null;
  time.value = 0;
}

void pauseTimer() {
  audioController.playPause();

  timer.value?.cancel();
  timer.value = null;
}

void incrementTime() {
  time.value += increment;
  if (timer.value == null || !timer.value!.isActive) {
    startTimer();
  }
}

void decrementTime() {
  time.value -= increment;
  if (time.value <= 0) {
    stopTimer();
  }
}

Computed getTimeCounter() {
  late final minutes = time() ~/ 60;
  late final seconds = time() % 60;
  return computed(() =>
      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}');
}

Computed getSignalGeneralState() {
  return computed(
      () => getGeneralState(timerState.value, timer.value, time.value));
}

Computed getTimer() {
  return computed(() => timer());
}

Computed getTime() {
  return computed(() => time());
}

Computed getCurrentStateText() {
  return computed(() => timeLimitsText.elementAt(timerState().index));
}

Computed getTimerState() {
  return computed(() => timerState());
}

void setSelectedState(TimerState s) {
  timerState.set(s);
  time.set(timeLimits.elementAt(s.index));
  audioController.playMovMenu();
}
