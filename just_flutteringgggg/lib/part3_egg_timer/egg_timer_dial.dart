import 'package:flutter/material.dart';

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
            child: /* Inner Circle */ Padding(
              padding: const EdgeInsets.all(60.0),
              child: Stack(
                children: [
                  CustomPaint(
                    painter: ArrowPainter(),
                  ),
                  Container(
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
                    child: /* Innermost circle */ Padding(
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
              ),
            ),
          ),
        ),
      ),
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
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
