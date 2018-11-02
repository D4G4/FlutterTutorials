import 'package:flutter/material.dart';

import 'package:flutter_challange_egg_timer/egg_timer_knob.dart';
import 'package:flutter_challange_egg_timer/helper/radial_drag_gesture_detector.dart';
import 'package:flutter_challange_egg_timer/egg_timer.dart';

import 'dart:math';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerDial extends StatefulWidget {
  final Duration currentTime;
  final Duration maxTime;
  final int ticksPerSection;
  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;
  final EggTimerState eggTimerState;

  EggTimerDial({
    this.currentTime = const Duration(minutes: 0),
    this.maxTime = const Duration(minutes: 35),
    this.ticksPerSection = 5,
    this.onTimeSelected,
    this.onDialStopTurning,
    this.eggTimerState,
  });

  @override
  _EggTimerDialState createState() => _EggTimerDialState();
}

class _EggTimerDialState extends State<EggTimerDial>
    with SingleTickerProviderStateMixin {
  static const RESET_SPEED_PERCENT_PER_SECONDS = 4;

  EggTimerState prevEggTimerState;
  double prevRotationPercent = 0.0;

  AnimationController resetToZeroController;
  Animation<double> resettingAnimation;

  _knobRotationPercent() =>
      widget.currentTime.inSeconds / widget.maxTime.inSeconds;

  // void _onTimeSelected(Duration duration) {
  //   print(duration.inMinutes);
  // }

  @override
  void initState() {
    resetToZeroController = AnimationController(vsync: this); //No duration
    super.initState();
  }

  @override
  void dispose() {
    resetToZeroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //If we hit the reset button and previous state was not Ready
    if (widget.currentTime.inSeconds == 0 &&
        prevEggTimerState != EggTimerState.ready) {
      //Run the animation
      resettingAnimation = new Tween(begin: prevRotationPercent, end: 0.0)
          .animate(resetToZeroController)
            ..addListener(() => setState(() {}))
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                setState(() {
                  resettingAnimation = null;
                });
              }
            });
      // resettingAnimation = Tween
      resetToZeroController.duration = Duration(
          milliseconds:
              ((prevRotationPercent / RESET_SPEED_PERCENT_PER_SECONDS) * 1000)
                  .round());
      resetToZeroController.forward(from: 0.0);
    }
    prevEggTimerState = widget.eggTimerState;
    prevRotationPercent = _knobRotationPercent();
    return DialTurnGestureDetector(
      maxTime: widget.maxTime,
      currentTime: widget.currentTime,
      onTimeSelected: widget.onTimeSelected,
      onDialStopTurning: widget.onDialStopTurning,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: AspectRatio(
            aspectRatio: 1.0, //Width = Height
            child: Container(
                //OutermostCircle
                width: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x44000000), //Black
                        blurRadius: 2.0,
                        spreadRadius: 1.0,
                        offset: Offset(0.0, 1.0))
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: const EdgeInsets.all(55.0),
                      child: CustomPaint(
                        painter: TickerPainter(
                            tickCount: widget.maxTime.inMinutes,
                            ticksPerSection: widget.ticksPerSection),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(65.0),
                      child: EggTimerDialKnob(
                        rotationPercent: resettingAnimation == null
                            ? _knobRotationPercent()
                            : resettingAnimation.value,
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class DialTurnGestureDetector extends StatefulWidget {
  final Widget child;
  final currentTime;
  final maxTime;
  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;

  DialTurnGestureDetector({
    this.child,
    this.maxTime,
    this.currentTime,
    this.onTimeSelected,
    this.onDialStopTurning,
  });

  @override
  _DialTurnGestureDetectorState createState() =>
      _DialTurnGestureDetectorState();
}

/// Systems do not talk like 0-360 but
/// 0 to 180 & 0 to -180
/// We need to understand what the current time is and only process the difference in angle
/// When the user drags, we care about the differnece in the angle
///
/// When you are in the top section (layman's first and second quadrant)
/// you are perceived to be in negative rotation and
/// when you are in the bottom (third and fourth quad) you are in +ve rotation.
///
/// Layman's = -> First Quadrant -> Fourth -> Third  = 0 -> 180°
/// Layman's = -> First Quadrant -> Second -> Third  = 0 -> -180°
class _DialTurnGestureDetectorState extends State<DialTurnGestureDetector> {
  PolarCoord startDragCoord;
  Duration startDragTime;
  Duration finalSelectedTime;

  /// We are maintaining startDragTime as our currentTime which will usually be 0
  /// so that from whatever position does the user start dragging, the actual dial should
  /// start rotating from 0:00 only;
  ///
  /// Analogy: (Max mins 35) user taps 5 and drags to 10, so rotate the dialer from 0 -> 5
  ///
  /// So find the angle of the radialDrag and visualize the clock
  /// find the number of seconds covered into that angle, starting from 0:00
  /// also, the angle only rotates clock wise
  /// In addition to that, the PolarCoord angle will range from -180 <-> +180
  /// You have to convert it into 360 to make the angle positive
  /// see `_makeAnglePositive(double angle)`
  _onRadialDragStart(PolarCoord coordinates) {
    print("egg_timer_dial     _onRadialDragStart");
    startDragCoord = coordinates;
    startDragTime = widget.currentTime;
  }

  _onRadialDragUpdate(PolarCoord coordinates) {
    print("egg_timer_dial     _onRadialDragUpdate");
    print("egg_timer_dial     StartAngle ${startDragCoord.angle}");
    print("egg_timer_dial     CoordAngle ${coordinates.angle}");
    //We have already received start
    if (startDragCoord != null) {
      final angleDiff =
          _makeAnglePositive(coordinates.angle - startDragCoord.angle);
      //If user drags from 5 to 10, just get the angle difference.
      print(
          "egg_timer_dial     AngleDifference ${(coordinates.angle - startDragCoord.angle)}");
      print("egg_timer_dial    Positive AngleDifference $angleDiff");

      final anglePercentSwing = angleDiff / (2 * pi); //Angle swing
      print("egg_timer_dial    anglePercent $anglePercentSwing");
      final timeDiffInSeconds =
          (anglePercentSwing * widget.maxTime.inSeconds).round();
      finalSelectedTime =
          Duration(seconds: startDragTime.inSeconds + timeDiffInSeconds);
      widget.onTimeSelected(finalSelectedTime);
    }
  }

  _makeAnglePositive(double angle) => angle >= 0 ? angle : angle + 2 * pi;

  _onRadialDragEnd() {
    widget.onDialStopTurning(finalSelectedTime);
    startDragCoord = null;
    finalSelectedTime = null;
  }

  @override
  Widget build(BuildContext context) {
    return RadialDragGestureDetector(
      child: widget.child,
      onRadialDragStart: _onRadialDragStart,
      onRadialDragUpdate: _onRadialDragUpdate,
      onRadialDragEnd: _onRadialDragEnd,
    );
  }
}

class TickerPainter extends CustomPainter {
  final LONG_TICK = 14.0;
  final SHORT_TICK = 4.0;

  final tickCount; //MaxTime in minutes
  final ticksPerSection;
  // final ticksInset;
  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  TickerPainter({
    this.tickCount = 35,
    this.ticksPerSection = 5,
    // this.ticksInset = 0.0,
  })  : tickPaint = Paint(),
        textPainter = TextPainter(
          textAlign: TextAlign.center,
          textDirection:
              TextDirection.ltr, //If you won't set that, it won't render
        ),
        textStyle = const TextStyle(
          color: Colors.black,
          fontFamily: 'BebasNeue',
          fontSize: 20.0,
        ) {
    tickPaint.color = Colors.black;
    tickPaint.strokeWidth = 1.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2); //Center

    canvas.save();

    final radius = size.width / 2;

    // -ve y-axis means up and -ve x-axis means left
    for (var i = 0; i < tickCount; i++) {
      final tickLength = i % ticksPerSection == 0 ? LONG_TICK : SHORT_TICK;
      canvas.drawLine(
        Offset(0.0, -radius),
        Offset(0.0, -radius - tickLength),
        tickPaint,
      );

      if (tickLength == LONG_TICK) {
        //Paint Text
        canvas.save();

        canvas.translate(0.0, -(radius) - 30.0); //30 px above tick mark

        textPainter.text = TextSpan(text: '$i', style: textStyle);

        //Layout the text

        //Computes the visual position of the glyphs for painting the text.
        textPainter.layout();

        // Cartizian Quadrant
        //Figure out which quadrant(counter clockWise) the text is in.
        //But flutter rotates in clock wise
        final tickPercent = i / tickCount;
        var quadrant;
        if (tickPercent < 0.25) {
          quadrant = 1; //TopRight
        } else if (tickPercent < 0.5) {
          quadrant = 4; //BottomRight
        } else if (tickPercent < 0.75) {
          quadrant = 3; //BottomLeft
        } else {
          quadrant = 2; //Top Left
        }

        switch (quadrant) {
          case 1:
            break;
          case 4:
            canvas.rotate(-pi / 2); // -90 deg
            break;
          case 2:
          case 3: //+90 deg
            canvas.rotate(pi / 2);
            break;
        }
        textPainter.paint(
            canvas,
            Offset(
              -textPainter.width / 2,
              -textPainter.height / 2,
            ));
        canvas.restore();
      }

      //Code operates in Radians
      canvas.rotate(2 * pi / tickCount);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(TickerPainter oldDelegate) {
    return true;
  }
}
