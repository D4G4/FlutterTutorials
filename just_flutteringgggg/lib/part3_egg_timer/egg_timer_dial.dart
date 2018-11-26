import 'package:flutter/material.dart';
import 'package:just_flutteringgggg/part3_egg_timer/egg_timer_knob.dart';
import 'dart:math';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerDial extends StatelessWidget {
  const EggTimerDial({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      painter: TickerAndTimePainter(),
                    ),
                  ),
                  EggTimerDialKnobWalaCircle(),
                ],
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
