import 'dart:async';

class EggTimer {
  EggTimerState state = EggTimerState.ready;
  final Duration maxTime;
  Duration _currentTime = const Duration(seconds: 0);
  Duration lastStartTime = const Duration(seconds: 0);
  final Stopwatch stopwatch = Stopwatch(); //It starts counting up from 0
  final Function onTimerUpdate;

  EggTimer({this.maxTime = const Duration(seconds: 0), this.onTimerUpdate});

  get currentTime => _currentTime;

  set currentTime(Duration newTime) {
    if (state == EggTimerState.ready) {
      _currentTime = newTime;
    }
    lastStartTime = _currentTime;
  }

  resume() {
    state = EggTimerState.running;
    stopwatch.start();

    _tick();
  }

  pause() {}

  _tick() {
    print('Current time: ${_currentTime.inSeconds}');
    //Timer isn't that acurate so we use Stopwatch
    //Stopwatch counts up, and we count down
    _currentTime = lastStartTime - stopwatch.elapsed;
    if (_currentTime.inSeconds > 0) {
      Timer(const Duration(seconds: 1), _tick);
    } else {
      state = EggTimerState.ready;
    }
    if (onTimerUpdate != null) {
      onTimerUpdate();
    }
  }
}

enum EggTimerState { ready, running, paused }
