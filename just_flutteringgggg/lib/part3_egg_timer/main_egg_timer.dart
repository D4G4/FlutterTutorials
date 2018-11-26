import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part3_egg_timer/time_display.dart';
import 'package:just_flutteringgggg/part3_egg_timer/egg_timer_controls.dart';
import 'package:just_flutteringgggg/part3_egg_timer/egg_timer_dial.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimer extends StatefulWidget {
  _EggTimerState createState() => _EggTimerState();
}

class _EggTimerState extends State<EggTimer> {
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
              EggTimerTimeDisplay(), // Time Text
              EggTimerDial(), // Dial
              Expanded(
                child: Container(),
              ),
              EggTimerControls(), // Buttons
            ],
          ),
        ),
      ),
    );
  }
}
