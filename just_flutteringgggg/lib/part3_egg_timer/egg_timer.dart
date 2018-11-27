import 'dart:async';

class EggTimerModel {
  EggTimerState state = EggTimerState.READY;
  final Duration maxTime;
  Duration _currentTime = Duration(minutes: 0);
  final Stopwatch stopwatch = Stopwatch();
  final Function() callback;

  Duration lastSelectedTime = const Duration(minutes: 0);
  Duration startTime;

  EggTimerModel({
    this.maxTime = const Duration(minutes: 35),
    this.callback,
  });

  get currentTime => _currentTime;

  set currentTime(Duration newTime) {
    if (state == EggTimerState.READY) {
      _currentTime = newTime;
      lastSelectedTime = _currentTime;
    }
  }

  void resume() {
    print('resuming');
    stopwatch.start();
    state = EggTimerState.RUNNING;
    startTime = _currentTime;
    _tick();
  }

  void pause() {}

  _tick() {
    _currentTime = startTime - stopwatch.elapsed;
    print('currentTime = ${_currentTime.inSeconds}');
    if (_currentTime.inSeconds > 0) {
      Timer(const Duration(seconds: 1), () => _tick());
    } else {
      stopwatch.reset();
      state = EggTimerState.READY;
      startTime = null;
    }
    if (null != callback) {
      callback();
    }
  }
}

enum EggTimerState {
  READY,
  RUNNING,
  PAUSED,
}
