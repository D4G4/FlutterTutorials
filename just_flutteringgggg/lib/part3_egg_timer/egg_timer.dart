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
    if (state != EggTimerState.RUNNING) {
      if (state == EggTimerState.READY) /**When user is letting go */ {
        _currentTime = _roundToTheNearestMinute(_currentTime);
        lastSelectedTime = _currentTime;
      }
      state = EggTimerState.RUNNING;
      stopwatch.start();
      startTime = _currentTime;
      _tick();
    }
  }

  void pause() {
    if (state == EggTimerState.RUNNING) {
      stopwatch.stop();
      stopwatch.reset();
      //lastSelectedTime = _currentTime;
      state = EggTimerState.PAUSED;
      if (null != callback) callback();
    }
  }

  // reset() {
  //   stopwatch.stop();
  //   state = EggTimerState.READY;
  //   _currentTime = Duration(minutes: 0);
  //   lastSelectedTime = Duration(minutes: 0);
  //   if (callback != null) callback();
  // }

  reset() {
    if (state == EggTimerState.PAUSED) {
      state = EggTimerState.READY;
      _currentTime = const Duration(seconds: 0);
      lastSelectedTime = _currentTime;
      stopwatch.reset();

      if (null != callback) {
        callback();
      }
    }
  }

  // restart() {
  //   stopwatch.reset();
  //   stopwatch.start();
  //   state = EggTimerState.RUNNING;
  //   _currentTime = Duration(minutes: 0);
  //   _tick();
  //   if (callback != null) callback();
  // }
  restart() {
    if (state == EggTimerState.PAUSED) {
      state = EggTimerState.RUNNING;
      _currentTime = lastSelectedTime;
      stopwatch.reset();
      stopwatch.start();
      _tick();
    }
  }

  _tick() {
    if (state == EggTimerState.RUNNING) {
      _currentTime = startTime - stopwatch.elapsed;
      //print('currentTime = ${_currentTime.inSeconds}');
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

  Duration _roundToTheNearestMinute(Duration currentTime) {
    return Duration(minutes: (currentTime.inSeconds / 60).round());
  }
}

enum EggTimerState {
  READY,
  RUNNING,
  PAUSED,
}
