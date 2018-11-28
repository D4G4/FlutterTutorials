import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part3_egg_timer/egg_timer_button.dart';
import 'package:just_flutteringgggg/part3_egg_timer/egg_timer.dart';

class EggTimerControls extends StatefulWidget {
  final EggTimerState state;

  final Function() onPause;
  final Function() onResume;
  final Function() onRestart;
  final Function() onReset;

  const EggTimerControls(
      {Key key,
      this.state,
      this.onPause,
      this.onResume,
      this.onReset,
      this.onRestart})
      : super(key: key);

  @override
  EggTimerControlsState createState() {
    return new EggTimerControlsState();
  }
}

class EggTimerControlsState extends State<EggTimerControls>
    with TickerProviderStateMixin {
  AnimationController pauseResumeSlideController;
  AnimationController restartResetFadeController;

  @override
  void initState() {
    super.initState();
    pauseResumeSlideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    pauseResumeSlideController.value = 1.0;
    restartResetFadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    restartResetFadeController.value = 1.0;
  }

  @override
  void dispose() {
    pauseResumeSlideController.dispose();
    restartResetFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.state) {
      case EggTimerState.READY:
        pauseResumeSlideController.forward();
        restartResetFadeController.forward();
        break;
      case EggTimerState.RUNNING:
        restartResetFadeController.forward();
        pauseResumeSlideController.reverse();
        break;
      case EggTimerState.PAUSED:
        restartResetFadeController.reverse();
        pauseResumeSlideController.reverse();
        break;
    }
    return Column(
      children: <Widget>[
        Opacity(
          opacity: 1.0 - restartResetFadeController.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              EggTimerButton(
                icon: Icons.refresh,
                text: 'RESTART',
                action: widget.onRestart,
              ),
              EggTimerButton(
                icon: Icons.arrow_back,
                text: 'RESET',
                action: widget.onReset,
              )
            ],
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            100 * pauseResumeSlideController.value,
            0.0,
          ),
          child: EggTimerButton(
            icon: widget.state == EggTimerState.RUNNING
                ? Icons.pause
                : Icons.play_arrow,
            text: widget.state == EggTimerState.RUNNING ? 'PAUSE' : 'PLAY',
            action: widget.state == EggTimerState.RUNNING
                ? widget.onPause
                : widget.onResume,
          ),
        )
      ],
    );
  }
}
