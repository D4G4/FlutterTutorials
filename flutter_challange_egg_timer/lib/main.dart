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
  final EggTimer eggTimer;

  _MyAppState()
      : eggTimer = EggTimer(
          maxTime: const Duration(
            minutes: 35,
          ),
        );

  _onTimeSelected(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              EggeTimerTimeDisplay(),
              EggTimerDial(
                currentTime: eggTimer.currentTime,
                maxTime: eggTimer.maxTime,
                ticksPerSection: 5,
                onTimeSelected: _onTimeSelected,
              ),
              Expanded(
                child: Container(),
              ),
              EggTimerControls()
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
