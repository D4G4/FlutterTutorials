import 'package:flutter/material.dart';

import 'package:just_flutteringgggg/part3_egg_timer/egg_timer_knob.dart';
import 'package:just_flutteringgggg/part3_egg_timer/egg_timer.dart';
import 'package:just_flutteringgggg/helper/radial_drag_gesture_detector.dart';

import 'dart:math';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerDial extends StatefulWidget {
  final Duration currentTime;
  final Duration maxTime; /* How many ticks to draw */
  final int ticksPerSection; /* Difference between long and short ticks */
  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;

  final EggTimerState state;

  const EggTimerDial({
    Key key,
    this.currentTime = const Duration(minutes: 0),
    this.maxTime = const Duration(minutes: 35),
    this.ticksPerSection = 5,
    this.onTimeSelected,
    this.onDialStopTurning,
    this.state,
  }) : super(key: key);

  @override
  EggTimerDialState createState() {
    return new EggTimerDialState();
  }
}

class EggTimerDialState extends State<EggTimerDial>
    with TickerProviderStateMixin {
  static const RESET_SPEED_PERCENT_PER_SECOND = 4.0;
  AnimationController resetToZeroController;
  Animation resetAnimation;

  EggTimerState previousState;
  double previousPercentage = 0.0;

  void initState() {
    super.initState();
    resetToZeroController = AnimationController(
      vsync:
          this, /** duration will be based on how far it needs to go. It should go faster the closer it is to 0 */
    );
  }

  @override
  void dispose() {
    resetToZeroController.dispose();
    super.dispose();
  }

  double _rotationPercent() {
    return widget.currentTime.inSeconds / widget.maxTime.inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    // print('Widget state = ${widget.state}');
    // print('Previous state= ${previousState}');
    if (widget.currentTime.inSeconds == 0 &&
        previousState != EggTimerState.READY) {
      //print('I am inside');
      resetAnimation = Tween(begin: previousPercentage, end: 0.0)
          .animate(resetToZeroController)
            ..addListener(() {
              setState(() {});
            })
            ..addStatusListener((status) {
              //print('status $status');
              if (status == AnimationStatus.completed) {
                //print('Resetting animation to null');
                setState(() {
                  resetAnimation = null;
                });
              }
            });
      //print('resetAnimation nulll? ${resetAnimation == null}');
      resetToZeroController.duration = Duration(
          milliseconds:
              ((previousPercentage / RESET_SPEED_PERCENT_PER_SECOND) * 1000)
                  .round());
      resetToZeroController.forward(from: 0.0);
    }

    previousState = widget.state;
    previousPercentage = _rotationPercent();

    return DialTurnGestureDetector(
      onTimeSelected: widget.onTimeSelected,
      onDialStopTurning: widget.onDialStopTurning,
      currentTime: widget.currentTime,
      maxTime: widget.maxTime,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: /* OuterCircle */ Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x44000000),
                    blurRadius: 2.0,
                    spreadRadius: 1.0,
                    offset: Offset(0.0, 1.0),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(60.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      /**The ticks and numbers */
                      width: double.infinity,
                      height: double.infinity,
                      child: CustomPaint(
                        painter: TickerAndTimePainter(
                          tickCount: widget.maxTime.inMinutes,
                          ticksPerCount: widget.ticksPerSection,
                        ),
                      ),
                    ),
                    EggTimerDialKnobWaleCircles(
                      rotationPercent: resetAnimation != null
                          ? resetAnimation.value
                          : _rotationPercent(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TickerAndTimePainter extends CustomPainter {
  final int tickCount;
  final int ticksPerCount;
  final ticksInset;

  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  TickerAndTimePainter({
    this.tickCount = 35,
    this.ticksPerCount = 5,
    this.ticksInset = 0,
  })  : tickPaint = Paint(),
        textPainter = TextPainter(
            textAlign: TextAlign.center,
            textDirection: TextDirection
                .ltr /*This is mandatory else you'll ran into error */),
        textStyle = const TextStyle(
          color: Colors.red,
          fontFamily: 'BebasNeue',
        ) {
    tickPaint.color = Colors.black;
    tickPaint.strokeWidth = 1.5; // .5 for Anti-Aliasing
  }

  @override
  bool shouldRepaint(TickerAndTimePainter oldDelegate) {
    return true;
  }

  final LONG_TICK_SIZE = 14.0;
  final SHORT_TICK_SIZE = 4.0;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    final radius = size.width / 2;
    canvas.translate(radius, size.height / 2); //Origin

    for (var i = 0; i < tickCount; i++) {
      var tickLength =
          (i % ticksPerCount) == 0 ? LONG_TICK_SIZE : SHORT_TICK_SIZE;
      canvas.drawLine(
          Offset(0.0, -radius), Offset(0.0, -radius - tickLength), tickPaint);

      if (tickLength == LONG_TICK_SIZE) {
        // Paint Text

        // finding quadrants
        var quadrant;

        if (i / tickCount < 0.25) {
          quadrant = 1;
        } else if (i / tickCount < 0.5) {
          quadrant = 4;
        } else if (i / tickCount < 0.75) {
          quadrant = 3;
        } else {
          quadrant = 2;
        }
        canvas.save();
        canvas.translate(0.0, -radius - 30.0);
        switch (quadrant) {
          case 4:
            canvas.rotate(-pi / 2);
            break;
          case 3:
          case 2:
            canvas.rotate(pi / 2);
            break;
        }

        textPainter.text = TextSpan(text: '$i', style: textStyle);

        // Layout the text-
        textPainter.layout();

        textPainter.paint(canvas,
            Offset(-textPainter.size.width / 2, -textPainter.size.height / 2));

        canvas.restore();
      }

      canvas.rotate(2 * pi / tickCount);
    }
    canvas.restore();
  }
}

class DialTurnGestureDetector extends StatefulWidget {
  final child;
  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;
  final Duration currentTime;
  final Duration maxTime;

  DialTurnGestureDetector({
    this.child,
    this.onTimeSelected,
    this.onDialStopTurning,
    this.currentTime,
    this.maxTime,
  });
  _DialTurnGestureDetectorState createState() =>
      _DialTurnGestureDetectorState();
}

class _DialTurnGestureDetectorState extends State<DialTurnGestureDetector> {
  Duration startDragTime;
  Duration selectedTime;
  //Duration startCurrentTime;
  PolarCoord startCoord;

  // _onDragStart(PolarCoord polarCoord) {
  //   startCurrentTime = widget.currentTime;
  //   var newTimeInSeconds = startCurrentTime.inSeconds +
  //       ((polarCoord.angle / (2 * pi)) * widget.maxTime.inSeconds).round();
  //   startDragTime = Duration(seconds: newTimeInSeconds);
  //   widget.onTimeSelected(startDragTime);
  //   startCoord = polarCoord;
  // }

  _onDragStart(PolarCoord polarCoord) {
    startCoord = polarCoord;
    startDragTime = widget.currentTime;
  }

  _onDragUpdate(PolarCoord polarCoord) {
    // print(polarCoord.toString());
    if (null != startCoord) {
      var swipedAngle = polarCoord.angle - startCoord.angle;
      swipedAngle = swipedAngle >= 0.0 ? swipedAngle : swipedAngle + (2 * pi);
      print('2 * pi = ${2 * pi}');
      double swipeAnglePercentage = swipedAngle / (2 * pi);

      // if (swipeAnglePercentage < 0) {
      //   swipeAnglePercentage = 1.0 + swipeAnglePercentage;
      //   print('swipedAnglePercentage $swipeAnglePercentage');
      // }

      final timeDiffInSeconds =
          (swipeAnglePercentage * widget.maxTime.inSeconds).round();

      final newTimeInSeconds = startDragTime.inSeconds + timeDiffInSeconds;
      selectedTime = Duration(seconds: newTimeInSeconds);

      if (null != widget.onTimeSelected) {
        widget.onTimeSelected(selectedTime);
      }
    }
  }

  _onDragEnd() {
    if (null != widget.onDialStopTurning) {
      widget.onDialStopTurning(selectedTime);
    }
    selectedTime = null;
    startCoord = null;
    startDragTime = null;
  }

  @override
  Widget build(BuildContext context) {
    return RadialDragGestureDetector(
      onRadialDragStart: _onDragStart,
      onRadialDragUpdate: _onDragUpdate,
      onRadialDragEnd: _onDragEnd,
      child: widget.child,
    );
  }
}
