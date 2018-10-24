library my_lib;

import 'package:flutter/material.dart';
import 'package:flutter_challange_egg_timer/egg_timer_time_display.dart';
import 'package:flutter_challange_egg_timer/egg_timer_controls.dart';
import 'package:flutter_challange_egg_timer/egg_timer_dial.dart';
import 'package:flutter_challange_egg_timer/egg_timer.dart';

void main() => runApp(EggTimerApp());

class EggTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Egg Timer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyApp(),
      );
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  EggTimer eggTimer;

  _MyAppState() {
    eggTimer = EggTimer(
        maxTime: const Duration(
          minutes: 10,
        ),
        onTimerUpdate: _onTimerUpdate);
  }

  _onTimeSelected(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
    });
  }

  _onTimerUpdate() {
    print('_onTimerUpdate()');
    print(eggTimer.currentTime.toString());
    setState(() {});
  }

  _onDialStopTurning(Duration finalTime) {
    setState(() {
      eggTimer.currentTime = finalTime;
      eggTimer.resume();
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              EggTimerTimeDisplay(
                eggTimerState: eggTimer.state,
                selectionTime: eggTimer.lastStartTime,
                countdownTime: eggTimer.currentTime,
              ),
              EggTimerDial(
                currentTime: eggTimer.currentTime,
                maxTime: eggTimer.maxTime,
                ticksPerSection: 2,
                onTimeSelected: _onTimeSelected,
                onDialStopTurning: _onDialStopTurning,
                eggTimerState: eggTimer.state,
              ),
              Expanded(
                child: Container(),
              ),
              EggTimerControls(
                eggTimerState: eggTimer.state,
                onPause: () {
                  setState(() {
                    eggTimer.pause();
                  });
                },
                onResume: () {
                  setState(() {
                    eggTimer.resume();
                  });
                },
                onReset: () {
                  setState(() {
                    eggTimer.reset();
                  });
                },
                onRestart: () {
                  setState(() {
                    eggTimer.restart();
                  });
                },
              )
            ],
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
            ),
          ),
        ),
      ),
    );
  }
}
