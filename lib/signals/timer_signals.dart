import 'package:signals/signals.dart';
import 'package:pomodoro/util/constants.dart';

final time = signal(timeLimits.elementAt(0)); 
final timerState = signal(TimerState.focus); 
final timerStateText = signal("Foco");
final timer = signal(null); 

void startTimer() {


}

void stopTimer() {

}


