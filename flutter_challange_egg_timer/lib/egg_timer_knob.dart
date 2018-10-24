import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_challange_egg_timer/egg_timer_dial.dart';

class EggTimerDialKnob extends StatefulWidget {
  final rotationPercent;

  EggTimerDialKnob({this.rotationPercent});
  @override
  _EggTimerDialKnobState createState() => _EggTimerDialKnobState();
}

//Rotate arrow and Icon
class _EggTimerDialKnobState extends State<EggTimerDialKnob> {
  @override
  Widget build(BuildContext context) => Stack(
        //Child of First Circle  (Outermost Circle)
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: ArrowPainter(rotationPercent: widget.rotationPercent),
            ),
          ),
          Container(
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
            padding: const EdgeInsets.all(10.0),
            child: Container(
              //Child of Second Circle
              width: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFFDFDFDF), //Off white,
                    width: 1.5),
              ),
              child: Center(
                child: Transform(
                  transform: Matrix4.rotationZ(2 * pi * widget.rotationPercent),
                  alignment: Alignment.center,
                  child: Image.network(
                    'https://avatars3.githubusercontent.com/u/14101776?s=400&v=4',
                    width: 50.0,
                    height: 50.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          // Container(
          //   width: double.infinity,
          //   height: double.infinity,
          //   child: CustomPaint(
          //     painter: ArrowPainter(rotationPercent: widget.rotationPercent),
          //   ),
          // ),
        ],
      );
}

class ArrowPainter extends CustomPainter {
  final Paint dialArrowPaint;
  final rotationPercent;

  ArrowPainter({this.rotationPercent = 0.0}) : dialArrowPaint = Paint() {
    dialArrowPaint.color = Colors.black;
    dialArrowPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save(); //Saving canvas position
    final radius = size.height / 2;
    canvas.translate(radius, radius);

    canvas.rotate(2 * pi * rotationPercent);
    Path path = Path();
    //path.moveTo(0.0, 0.0);
    path.moveTo(0.0, -radius - 10.0);
    path.lineTo(10.0, -radius + 5.0); //Diaognal line of 45deg
    path.lineTo(-10.0, -radius + 5.0);
    path.close();

    canvas.drawPath(path, dialArrowPaint);
    canvas.drawShadow(path, Colors.black, 3.0, false);

    canvas.restore();
  }

  bool shouldRepaint(ArrowPainter oldDelegate) {
    return true;
  }
}
