import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part3_egg_timer/time_display.dart';
import 'package:just_flutteringgggg/part3_egg_timer/egg_timer_controls.dart';
import 'package:just_flutteringgggg/part3_egg_timer/egg_timer_dial.dart';
import 'package:just_flutteringgggg/part3_egg_timer/egg_timer.dart';

//ambiggn.addidas@gmail.com

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimer extends StatefulWidget {
  _EggTimerState createState() => _EggTimerState();
}

class _EggTimerState extends State<EggTimer> {
  EggTimerModel eggTimer;

  _EggTimerState() {
    eggTimer = EggTimerModel(
      maxTime: const Duration(minutes: 35),
      callback: _onTimerUpdate,
    );
  }

  void _onTimerUpdate() {
    setState(() {});
  }

  int _getTicksPerSection() {
    int minutes = eggTimer.maxTime.inMinutes;
    int ticksPerSection = 0;
    for (var i = 2; i < minutes; i++) {
      if (minutes % i == 0) {
        ticksPerSection = i;
        break;
      }
    }
    return ticksPerSection;
  }

  _onTimeSelected(Duration newTime) {
    // print('onTimeSelected $newTime');
    setState(() {
      eggTimer.currentTime = newTime;
    });
  }

  _onDialStopTurning(Duration newTime) {
    eggTimer.currentTime = newTime;
    eggTimer.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
          ),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              EggTimerTimeDisplay(
                countdownTime: eggTimer.currentTime,
                selectedTime: eggTimer.lastSelectedTime,
                state: eggTimer.state,
              ), // Time Text
              EggTimerDial(
                state: eggTimer.state,
                maxTime: eggTimer.maxTime,
                currentTime: eggTimer.currentTime,
                ticksPerSection: 5,
                onTimeSelected: _onTimeSelected,
                onDialStopTurning: _onDialStopTurning,
              ), // Dial
              Expanded(
                child: Container(),
              ),
              EggTimerControls(
                state: eggTimer.state,
                onPause: eggTimer.pause,
                onResume: eggTimer.resume,
                onReset: eggTimer.reset,
                onRestart: eggTimer.restart,
              ), // Buttons
            ],
          ),
        ),
      ),
    );
  }
}
