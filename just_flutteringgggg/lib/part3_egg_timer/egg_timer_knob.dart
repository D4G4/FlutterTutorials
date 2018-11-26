import 'package:flutter/material.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerDialKnobWalaCircle extends StatefulWidget {
  _EggTimerDialKnobWalaCircleState createState() =>
      _EggTimerDialKnobWalaCircleState();
}

class _EggTimerDialKnobWalaCircleState
    extends State<EggTimerDialKnobWalaCircle> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          /* Just the knob */
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: ArrowPainter(),
          ),
        ),
        Container(
          /**Circle 2 */
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
            /* Innermost circle */
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFDFDFDF),
                  width: 1.5,
                ),
              ),
              child: Center(
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
      ],
    );
  }
}

/* Is being build in innerCircle (beneath InnermostCircle) */
class ArrowPainter extends CustomPainter {
  final Paint dialArrowPaint;

  ArrowPainter() : dialArrowPaint = Paint() {
    dialArrowPaint.color = Colors.black;
    dialArrowPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    canvas.translate(size.width / 2, 0.0);

    Path path = Path();
    path.moveTo(0.0, -10.0); //Going up
    path.lineTo(10.0, 5.0); //Going down and to the right
    path.lineTo(-10.0, 5.0); //Going to bottom left
    path.close();

    canvas.drawPath(path, dialArrowPaint);
    canvas.drawShadow(path, Colors.red, 3.0, false);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
