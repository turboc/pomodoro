const increment = 600;

const String gongoSound = 'audio/final.mp3';
const String panicGongoSound = 'audio/panic.mp3';
const String movMenu = 'audio/mov_menu.mp3';

const String stopSound = 'audio/stop.mp3';
const String startSound = 'audio/start.mp3';
const String pauseSound = 'audio/pause.wav';


enum TimerState { focus, shortBreak, longBreak }

enum GeneralState { everyThingStopped, focusRunning, focusPaused, focusStopped, shortBreakRunning, shortBreakPaused, shortBreakStopped, longBreakRunning, longBreakPaused, longBreakStopped }

const Set<int> timeLimits = {1800, 600, 1200}; //{5, 6, 7}


const Set<String> timeLimitsText = {"Foco", "Intervalo breve", "Intervalo longo"};

const String imageCheering = 'assets/images/yy_cheering.png';
const String imageOk = 'assets/images/yy_ok.png';
const String imageSitting = 'assets/images/yy_sitting.png';
const String imageSleeping = 'assets/images/yy_sleeping.png';
const String imageLunch = 'assets/images/yy_lunch.png';
const String imageSmiling = 'assets/images/yy_smiling.png';
const String imageIknow = 'assets/images/yy_iknow.png';
const String imageFloor = 'assets/images/yy_floor.png';

