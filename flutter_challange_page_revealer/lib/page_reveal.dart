//Will have the ability to reveal any widget as a circle

import 'package:flutter/material.dart';
import 'dart:math';

class PageReveal extends StatelessWidget {
  final double revealPercent;
  final Widget child;

  PageReveal({this.revealPercent = 0.1, this.child});

  @override
  Widget build(BuildContext context) => ClipOval(
      //Confine visibility of the child to a oval
      child: child,
      clipper: CircleRevealClipper(revealPercent));
}

//Why custom? Because by default, the clipper starts from the center
class CircleRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;
  CircleRevealClipper(this.revealPercent);

  @override
  Rect getClip(Size size) {
    //Center of the circel, which will be bottom of the screene
    final epicenter = Offset(size.width / 2, size.height * 0.9);

    //Calculate distance from epicenter to the top left corner to make sure we fill the screen
    //Bcz, be default the circle will just touch the top-center of the screen due to it's shape
    //thus, topLeft and topRight will be left untouched

    //arc inverse-tangent in radians
    double theta = atan(epicenter.dy / epicenter.dx);
    final distanceToCorner = epicenter.dy / sin(theta);

    final radius = distanceToCorner * revealPercent;
    final diameter = 2 * radius;

    //It will return a Square which will be clipped/confined to an Oval/Circular shape
    return new Rect.fromLTWH(
      epicenter.dx - radius,
      epicenter.dy - radius,
      diameter,
      diameter,
    );
  }

  @override
  bool shouldReclip(CircleRevealClipper oldClipper) =>
      oldClipper.revealPercent != revealPercent;
}
