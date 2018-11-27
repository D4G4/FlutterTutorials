import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part3_egg_timer/egg_timer.dart';
import 'package:intl/intl.dart';

class EggTimerTimeDisplay extends StatefulWidget {
  final Duration selectedTime;
  final EggTimerState state;
  final Duration countdownTime;

  EggTimerTimeDisplay({
    this.selectedTime,
    this.state,
    this.countdownTime,
  });
  _EggTimerTimeDisplayState createState() => _EggTimerTimeDisplayState();
}

class _EggTimerTimeDisplayState extends State<EggTimerTimeDisplay>
    with TickerProviderStateMixin {
  final DateFormat selectionTimeFormat = DateFormat('mm');
  final DateFormat countdownTimeFormat = DateFormat('mm:ss');

  AnimationController slideUpController;
  AnimationController opacityController;

  void initState() {
    super.initState();
    slideUpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });

    opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });

    opacityController.value = 1; //Initially, countdownTime will be invisible
  }

  @override
  void dispose() {
    slideUpController.dispose();
    opacityController.dispose();
    super.dispose();
  }

  String _formattedSelectionTime() {
    DateTime selectionTime = DateTime(
        DateTime.now().year, 0, 0, 0, 0, widget.selectedTime.inSeconds);
    return selectionTimeFormat.format(selectionTime);
  }

  String _formattedCountdownTime() {
    DateTime countdownTime = DateTime(
        DateTime.now().year, 0, 0, 0, 0, widget.countdownTime.inSeconds);
    return countdownTimeFormat.format(countdownTime);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state == EggTimerState.READY) {
      slideUpController.reverse();
      opacityController.forward();
    } else {
      slideUpController.forward();
      opacityController.reverse();
    }
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Transform(
              transform: Matrix4.translationValues(
                  0.0, -200 * slideUpController.value, 0.0),
              child: Text(
                /*Minutes text */
                _formattedSelectionTime(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'BebasNeue',
                  fontSize: 110.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Opacity(
              opacity: 1 - opacityController.value,
              child: Text(
                /* Minutes with seconds */
                _formattedCountdownTime(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'BebasNeue',
                  fontSize: 110.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
