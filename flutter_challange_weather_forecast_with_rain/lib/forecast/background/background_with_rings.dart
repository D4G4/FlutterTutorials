import 'package:flutter/material.dart';

class BackgroundWithRings extends StatelessWidget {
  @override
  Widget build(context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          'assets/weather-bk_enlarged.png',
          fit: BoxFit.cover,
        ),
        ClipOval(
          clipper: CircleClipper(
            radius: 140.0,
            offset: const Offset(40.0, 0.0),
          ),
          child: Image.asset(
            'assets/weather-bk.png',
            fit: BoxFit.cover,
          ),
        ),
        CustomPaint(
          painter: WhiteCircleCutoutPainter(
            centerOffset: Offset(40.0, 0.0),
            circles: [
              Circle(radius: 140.0, alpha: 0x10),
              Circle(radius: 140.0 + 15.0, alpha: 0x28),
              Circle(radius: 140.0 + 35.0, alpha: 0x38),
              Circle(radius: 140.0 + 75.0, alpha: 0x50),
            ],
          ),
          child:
              Container(), //To make sure that the Painter actually paints, we are gonna throw away the child
        )
      ],
    );
  }
}

class CircleClipper extends CustomClipper<Rect> {
  final double radius;
  final Offset offset;

  CircleClipper({this.radius, this.offset});

  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
      center: Offset(0.0, size.height / 2) + offset,
      radius: radius,
    );
  }

  @override
  bool shouldReclip(CircleClipper oldDelegate) {
    return true;
  }
}

class WhiteCircleCutoutPainter extends CustomPainter {
  final Color overlayColor = const Color(0xFFAA88AA);

  final Offset centerOffset;
  final List<Circle> circles;
  final Paint whitePaint;
  final Paint borderPaint;

  WhiteCircleCutoutPainter({
    this.circles = const [],
    this.centerOffset = const Offset(0.0, 0.0),
  })  : whitePaint = Paint(),
        borderPaint = Paint() {
    borderPaint
      ..color = const Color(0x10FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0;
  }

  _maskCircle(Canvas canvas, Size size, double radius) {
    Path clippedCircle = Path();

    //To mask a path, start with a larger space and cut out the path
    // we need to cover the whole screen then cut out the circle
    clippedCircle.fillType = PathFillType.evenOdd;

    //So, first get the rectangle of the size of the screen
    clippedCircle.addRect(Rect.fromLTRB(0.0, 0.0, size.width, size.height));

    clippedCircle.addOval(Rect.fromCircle(
      center: Offset(0.0, size.height / 2) + centerOffset,
      radius: radius,
    ));

    //Clipping means where you are "allowed" to paint
    //You are allowed to paint anywhere on the screen except the clippedPath that we have cutout
    canvas.clipPath(clippedCircle);

    //It's more like Making a rectangle and placing a oval over it then cut the oval part.
  }

  @override
  void paint(Canvas canvas, Size size) {
    // in each iteration, we will loop through two different circles
    // bcz a "Ring" is a two circles, the inner and the outer
    // two process the 0th circle, we also need to process the i+1th circle
    for (var i = 1; i < circles.length; ++i) {
      _maskCircle(
        canvas,
        size,
        circles[i - 1].radius,
      ); //Inner circle is the circle we want to mask against

      whitePaint.color = overlayColor.withAlpha(circles[i - 1].alpha);

      //Fill circle
      canvas.drawCircle(
        Offset(0.0, size.height / 2) + centerOffset,
        circles[i].radius,
        whitePaint,
      );

      // Draw circle bevel
      canvas.drawCircle(Offset(0.0, size.height / 2) + centerOffset,
          circles[i - 1].radius, borderPaint);
    }
    // Mask the area of final circle
    _maskCircle(canvas, size, circles.last.radius);

    // Draw an overlay that fills rest of the screen
    whitePaint.color = overlayColor.withAlpha(circles.last.alpha);

    canvas.drawRect(
        Rect.fromLTRB(0.0, 0.0, size.width, size.height), whitePaint);

    // Draw the bevel for the final circle
    canvas.drawCircle(
      Offset(0.0, size.height / 2) + centerOffset,
      circles.last.radius,
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(WhiteCircleCutoutPainter oldDelegate) {
    return true;
  }
}

class Circle {
  final double radius;
  final int alpha;

  Circle({
    this.radius,
    this.alpha = 0xFF,
  });
}
