class EggTimer {
  EggTimerState state = EggTimerState.ready;
  final Duration maxTime;
  Duration _currentTime = const Duration(seconds: 0);

  EggTimer({
    this.maxTime = const Duration(seconds: 0),
  });

  get currentTime => _currentTime;

  set currentTime(Duration newTime) {
    if (state == EggTimerState.ready) {
      _currentTime = newTime;
    }
  }
}

enum EggTimerState { ready, running, paused }
