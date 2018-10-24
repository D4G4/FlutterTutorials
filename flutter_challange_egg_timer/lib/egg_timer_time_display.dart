import 'package:flutter/material.dart';

import 'package:flutter_challange_egg_timer/egg_timer.dart';

import 'package:intl/intl.dart';

class EggTimerTimeDisplay extends StatefulWidget {
  final eggTimerState;
  final selectionTime;
  final countdownTime;

  EggTimerTimeDisplay({
    this.eggTimerState,
    this.selectionTime = const Duration(seconds: 0),
    this.countdownTime = const Duration(seconds: 0),
  });

  @override
  _EggTimerTimeDisplayState createState() => _EggTimerTimeDisplayState();
}

class _EggTimerTimeDisplayState extends State<EggTimerTimeDisplay>
    with TickerProviderStateMixin {
  final DateFormat selectionTimeFormat = DateFormat("mm");
  final DateFormat countdownTimeFormat = DateFormat("mm:ss");

  AnimationController selectionTimeSlideController;
  AnimationController countdownTimeFadeController;

  @override
  initState() {
    selectionTimeSlideController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..addListener(() {
            setState(() {});
          });

    countdownTimeFadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(() {
            setState(() {});
          });

    // selectionTimeSlideController.addStatusListener((AnimationStatus status) {
    //   if (status == AnimationStatus.completed) {
    //     countdownTimeFadeController.forward();
    //   }
    // });
    countdownTimeFadeController.value = 1.0; //Completely faded out
    super.initState();
  }

  @override
  void dispose() {
    selectionTimeSlideController.dispose();
    countdownTimeFadeController.dispose();
    super.dispose();
  }

  get _formattedSelectionTime {
    DateTime dateTime = DateTime(
        DateTime.now().year, 0, 0, 0, 0, widget.selectionTime.inSeconds);
    return selectionTimeFormat.format(dateTime);
  }

  get _formattedCountdownTime {
    DateTime dateTime = DateTime(
        DateTime.now().year, 0, 0, 0, 0, widget.countdownTime.inSeconds);
    return countdownTimeFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.eggTimerState == EggTimerState.ready) {
      selectionTimeSlideController.reverse();
      countdownTimeFadeController.forward();
    } else {
      selectionTimeSlideController.forward();
      countdownTimeFadeController.reverse();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Transform(
            transform: Matrix4.translationValues(
              0.0,
              -200.0 * selectionTimeSlideController.value,
              0.0,
            ),
            child: Text(
              _formattedSelectionTime,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 100.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10.0,
                  color: Colors.black,
                  fontFamily: 'BebasNeue'),
            ),
          ),
          Opacity(
            opacity: 1.0 - countdownTimeFadeController.value,
            //opacity:AnimatedOpacity,
            child: Text(
              _formattedCountdownTime,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 100.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10.0,
                  color: Colors.black,
                  fontFamily: 'BebasNeue'),
            ),
          )
        ],
      ),
    );
  }
}
