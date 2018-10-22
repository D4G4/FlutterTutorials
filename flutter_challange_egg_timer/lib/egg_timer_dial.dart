import 'package:flutter/material.dart';
import 'package:flutter_challange_egg_timer/egg_timer_knob.dart';
import 'dart:math';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerDial extends StatefulWidget {
  final Duration currentTime;
  final Duration maxTime;
  final int ticksPerSection;
  final Function(Duration) onTimeSelected;

  EggTimerDial(
      {this.currentTime = const Duration(minutes: 0),
      this.maxTime = const Duration(minutes: 35),
      this.ticksPerSection = 5,
      this.onTimeSelected});

  @override
  _EggTimerDialState createState() => _EggTimerDialState();
}

class _EggTimerDialState extends State<EggTimerDial> {
  _rotationPercent() => widget.currentTime.inSeconds / widget.maxTime.inSeconds;

  @override
  Widget build(BuildContext context) => DialTurnGestureDetector(
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
                            rotationPercent: _rotationPercent()),
                      )
                    ],
                  )),
            ),
          ),
        ),
      );
}

class DialTurnGestureDetector extends StatefulWidget {
  Widget child;

  DialTurnGestureDetector({this.child});

  @override
  _DialTurnGestureDetectorState createState() =>
      _DialTurnGestureDetectorState();
}

class _DialTurnGestureDetectorState extends State<DialTurnGestureDetector> {
  @override
  Widget build(BuildContext context) {
    return RadialDragGestureDetector(
      child: widget.child,
    );
  }
}

class TickerPainter extends CustomPainter {
  final LONG_TICK = 14.0;
  final SHORT_TICK = 4.0;

  final tickCount;
  final ticksPerSection;
  final ticksInset;
  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  TickerPainter({
    this.tickCount = 35,
    this.ticksPerSection = 5,
    this.ticksInset = 0.0,
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
