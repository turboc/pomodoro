import 'dart:async';

import 'package:pomodoro/util/constants.dart';

GeneralState getGeneralState(TimerState timerState, Timer? timer, int time) {

  bool hasTimerActive = timer != null && timer.isActive;
  bool hasTime = time > 0;

  switch(timerState) {
    case TimerState.focus: {
      if (hasTimerActive && hasTime) return GeneralState.focusRunning;
      if ((hasTimerActive) && (!hasTime)) return GeneralState.focusStopped;
      if (hasTime) return GeneralState.focusPaused;
    }
    case TimerState.shortBreak: {
      if (hasTimerActive && hasTime) return GeneralState.shortBreakRunning;
      if ((hasTimerActive) && (!hasTime)) return GeneralState.shortBreakStopped;
      if (hasTime) return GeneralState.shortBreakPaused;
    }
    case TimerState.longBreak: {
      if (hasTimerActive && hasTime) return GeneralState.longBreakRunning;
      if ((hasTimerActive) && (!hasTime)) return GeneralState.longBreakStopped;
      if (hasTime ) return GeneralState.longBreakPaused;
    }

  }
  return GeneralState.everyThingStopped;
}